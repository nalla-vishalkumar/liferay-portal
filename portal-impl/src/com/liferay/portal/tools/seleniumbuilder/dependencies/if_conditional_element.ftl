<#assign conditionalCaseNames = ["and", "condition", "contains", "equals", "isset", "not", "or"]>

<#if ifConditionalElement.getName() == "and">
		<#assign conditionalCases = ifConditionalElement.elements()>

		<#assign firstCase = true>

		(
			<#list conditionalCases as conditionalCase>
				<#if conditionalCaseNames?seq_contains(conditionalCase.getName())>
					<#assign ifConditionalElement = conditionalCase>

					<#include "if_conditional_element.ftl">
				</#if>

				<#if conditionalCase_has_next>
					&&
				</#if>
			</#list>
		)
<#elseif ifConditionalElement.getName() == "condition">
	<#if ifConditionalElement.attributeValue("action")??>
		<#assign actionElement = ifConditionalElement>

		(<#include "action_log_element.ftl">) && (<#include "action_element.ftl">)
	<#elseif ifConditionalElement.attributeValue("macro")??>
		<#assign macroElement = ifConditionalElement>

		<#include "macro_element.ftl">
	</#if>
<#elseif ifConditionalElement.getName() == "contains">
	<#assign string = ifConditionalElement.attributeValue("string")>

	<#assign substring = ifConditionalElement.attributeValue("substring")>

	(RuntimeVariables.evaluateVariable("${string}", commandScopeVariables)).contains(RuntimeVariables.evaluateVariable("${substring}", commandScopeVariables))
<#elseif ifConditionalElement.getName() == "equals">
	<#assign arg1 = ifConditionalElement.attributeValue("arg1")>

	<#assign arg2 = ifConditionalElement.attributeValue("arg2")>

	(RuntimeVariables.evaluateVariable("${arg1}", commandScopeVariables)).equals(RuntimeVariables.evaluateVariable("${arg2}", commandScopeVariables))
<#elseif ifConditionalElement.getName() == "isset">
	<#assign var = ifConditionalElement.attributeValue("var")>

	RuntimeVariables.variableExists(RuntimeVariables.evaluateVariable("${var}", commandScopeVariables), commandScopeVariables)
<#elseif ifConditionalElement.getName() == "not">
	!(
		<#if ifConditionalElement.element("and")??>
			<#assign ifConditionalElement = ifConditionalElement.element("and")>
		<#elseif ifConditionalElement.element("condition")??>
			<#assign ifConditionalElement = ifConditionalElement.element("condition")>
		<#elseif ifConditionalElement.element("contains")??>
			<#assign ifConditionalElement = ifConditionalElement.element("contains")>
		<#elseif ifConditionalElement.element("equals")??>
			<#assign ifConditionalElement = ifConditionalElement.element("equals")>
		<#elseif ifConditionalElement.element("isset")??>
			<#assign ifConditionalElement = ifConditionalElement.element("isset")>
		<#elseif ifConditionalElement.element("not")??>
			<#assign ifConditionalElement = ifConditionalElement.element("not")>
		<#elseif ifConditionalElement.element("or")??>
			<#assign ifConditionalElement = ifConditionalElement.element("or")>
		</#if>

		<#include "if_conditional_element.ftl">
	)
<#elseif ifConditionalElement.getName() == "or" >
		<#assign conditionalCases = ifConditionalElement.elements()>

		<#assign firstCase = true>

		(
			<#list conditionalCases as conditionalCase>
				<#if conditionalCaseNames?seq_contains(conditionalCase.getName())>
					<#assign ifConditionalElement = conditionalCase>

					<#include "if_conditional_element.ftl">
				</#if>

				<#if conditionalCase_has_next>
					||
				</#if>
			</#list>
		)
</#if>