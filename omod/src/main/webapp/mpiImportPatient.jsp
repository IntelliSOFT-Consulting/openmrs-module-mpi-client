<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<spring:htmlEscape defaultHtmlEscape="true" />
<openmrs:require privilege="View Patients" otherwise="/login.htm" redirect="/index.htm" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables_jui.css"/>
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js"/>
<openmrs:htmlInclude file="/scripts/jquery-ui/js/openmrsSearch.js" />

<h2>Import MPI Patient</h2>
<p>The remote demographic record will be imported into OpenMRS as the following demographic record:</p>

<form id="importForm" modelAttribute="importPatient" method="post"
			enctype="multipart/form-data">
	<div class="boxHeader"><openmrs:message code="Patient.title"/></div>
	<div class="box$">
		<table class="personName">
			<thead>
				<tr class="patientDemographicsHeaderRow">
					<th class="patientDemographicsPersonNameHeader"><openmrs:message code="Person.names"/></th>
					<openmrs:forEachDisplayAttributeType personType="patient" displayType="viewing" var="attrType">
						<th class="patientDemographicsPersonAttTypeHeader"><openmrs:message code="PersonAttributeType.${fn:replace(attrType.name, ' ', '')}" text="${attrType.name}"/></th>
					</openmrs:forEachDisplayAttributeType>
				</tr>
			</thead>
			<tbody>
				<tr class="patientDemographicsRow">
					<td valign="top" class="patientDemographicsData" >
						<c:forEach var="name" items="${patient.names}" varStatus="status">
							<c:if test="${!name.voided}">
								<% request.setAttribute("name", pageContext.getAttribute("name")); %>
								<spring:nestedPath path="name">
									<openmrs:portlet url="nameLayout" id="namePortlet" size="quickView" parameters="layoutShowExtended=true" />
								</spring:nestedPath>
							</c:if>
						</c:forEach>
					</td>
					<openmrs:forEachDisplayAttributeType personType="patient" displayType="viewing" var="attrType">
						<td valign="top" class="patientDemographicsAttrName">${patient.attributeMap[attrType.name]}</td>
					</openmrs:forEachDisplayAttributeType>
				</tr>
			</tbody>
		</table>
	</div>
	
	<br/>
	
	<div class="boxHeader"><openmrs:message code="Person.addresses"/></div>
	<div class="box">
		<table class="personAddress">
			<thead>
				<openmrs:portlet url="addressLayout" id="addressPortlet" size="columnHeaders" parameters="layoutShowTable=false|layoutShowExtended=true" />
			</thead>
			<tbody>
				<c:forEach var="address" items="${patient.addresses}" varStatus="status">
					<c:if test="${!address.voided}">
					<% request.setAttribute("address", pageContext.getAttribute("address")); %>
					<spring:nestedPath path="address">
						<openmrs:portlet url="addressLayout" id="addressPortlet" size="inOneRow" parameters="layoutMode=view|layoutShowTable=false|layoutShowExtended=true" />
					</spring:nestedPath>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<p>If you're satisfied with the data provided click the "import" button below.</p>
	<br /> <input type="submit" value="Import Patient" style="float:right"> <br />
</form>


<%@ include file="/WEB-INF/template/footer.jsp"%>
