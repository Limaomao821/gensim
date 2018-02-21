#include "define.h"
#include "genC/Intrinsics.h"
#include "genC/Parser.h"
#include "genC/ir/IRType.h"
#include "genC/ir/IRAction.h"
#include "genC/ir/IRSignature.h"
#include "genC/ir/IR.h"
#include "genC/ssa/SSABuilder.h"
#include "genC/ssa/statement/SSAStatements.h"
#include "genC/ssa/SSAContext.h"

using namespace gensim;
using namespace gensim::genc;
using namespace gensim::genc::ssa;

void GenCContext::AddExternalFunction(const std::string& name, const IRType& retty, const IRSignature::param_type_list_t& ptl)
{
	if (ExternalTable.count(name) != 0) {
		throw std::logic_error("External function with the name '" + name + "' is already registered.");
	}

	IRSignature sig(name, retty, ptl);
	sig.AddAttribute(gensim::genc::ActionAttribute::External);
	ExternalTable[name] = new IRExternalAction(sig, *this);
}

static const IRType &WordType(const arch::ArchDescription *arch)
{
	switch(arch->wordsize) {
		case 32: return IRTypes::UInt32;
		case 64: return IRTypes::UInt64;
		default: UNIMPLEMENTED;
	}
}

void GenCContext::LoadExternalFunctions()
{
	const IRType &wordtype = WordType(&Arch);

	AddExternalFunction("__builtin_external_call", IRTypes::Void, {});
	
	// TLB Maintenance
	AddExternalFunction("flush", IRTypes::Void, {});
	AddExternalFunction("flush_dtlb", IRTypes::Void, {});
	AddExternalFunction("flush_itlb", IRTypes::Void, {});
	AddExternalFunction("flush_dtlb_entry", IRTypes::Void, {IRParam("addr", IRTypes::UInt64)});
	AddExternalFunction("flush_itlb_entry", IRTypes::Void, {IRParam("addr", IRTypes::UInt64)});
	AddExternalFunction("pgt_change", IRTypes::Void, {});
}

SSAStatement *IRCallExpression::EmitExternalCall(SSABuilder &bldr, const gensim::arch::ArchDescription &Arch) const
{
	auto target = dynamic_cast<IRExternalAction *>(Target);
	if (target == nullptr) {
		throw std::logic_error("Target of external call is not an IRExternalAction");
	}
	
	SSAActionPrototype prototype(target->GetSignature());
	SSAExternalAction *target_action = nullptr;
	if(!bldr.Context.HasAction(prototype.GetIRSignature().GetName())) {
		target_action = new SSAExternalAction(bldr.Context, prototype);
		bldr.Context.AddAction(target_action);
	} else {
		target_action = static_cast<SSAExternalAction*>(bldr.Context.GetAction(prototype.GetIRSignature().GetName()));
	}
	
	std::vector<SSAValue *> arg_statements;
	
	auto params = target->GetSignature().GetParams();
	if (params.size() != Args.size()) throw std::logic_error("Argument/Parameter count mismatch when emitting external call '" + target->GetSignature().GetName() + "'");

	int arg_index = 0;
	for (const auto& arg : Args) {
		SSAStatement *arg_statement = arg->EmitSSAForm(bldr);

		auto param = params.at(arg_index++);
		if (arg_statement->GetType() != param.GetType()) {
			const auto& dn = arg_statement->GetDiag();
			arg_statement = new SSACastStatement(&bldr.GetBlock(), param.GetType(), arg_statement);
			arg_statement->SetDiag(dn);
		}

		arg_statements.push_back(arg_statement);
	}

	SSACallStatement *stmt = new SSACallStatement(&bldr.GetBlock(), target_action, arg_statements);
	stmt->SetDiag(Diag());

	return stmt;
}