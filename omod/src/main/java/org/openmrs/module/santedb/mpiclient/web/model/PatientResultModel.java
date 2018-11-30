package org.openmrs.module.santedb.mpiclient.web.model;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PersonName;
import org.openmrs.api.context.Context;
import org.openmrs.module.santedb.mpiclient.api.MpiClientService;
import org.openmrs.module.santedb.mpiclient.configuration.MpiClientConfiguration;
import org.openmrs.module.santedb.mpiclient.model.MpiPatient;

/**
 * Represents a result of a patient search 
 */
public class PatientResultModel {
	
	// Get the CDA handler configuration
	MpiClientConfiguration m_configuration = MpiClientConfiguration.getInstance();
	private final Log log = LogFactory.getLog(this.getClass());
	
	// Name
	private String givenName;
	// Family name
	private String familyName;
	// Gender
	private String gender;
	// Date of birth
	private String dateOfBirth;
	// Identifier
	private String identifier;
	// True
	private boolean isImported;
	// Open Mrs id
	private Integer openMrsId;
	// Ecid
	private String ecid;

    /**
     * @return the givenName
     */
    public String getGivenName() {
    	return givenName;
    }
	
    /**
     * @return the familyName
     */
    public String getFamilyName() {
    	return familyName;
    }
	
    /**
     * @return the gender
     */
    public String getGender() {
    	return gender;
    }
	
    /**
     * @return the dateOfBirth
     */
    public String getDateOfBirth() {
    	return dateOfBirth;
    }
	
    /**
     * @return the identifier
     */
    public String getIdentifier() {
    	return identifier;
    }
	
    /**
     * @return the isImported
     */
    public boolean getIsImported() {
    	return isImported;
    }
	
    /**
     * @return the openMrsId
     */
    public Integer getOpenMrsId() {
    	return openMrsId;
    }
	
    /**
     * @return the ecid
     */
    public String getEcid() {
    	return ecid;
    }

	/**
	 * Create a result from the model
	 */
	public PatientResultModel(MpiPatient result)
	{
		for(PersonName pn : result.getNames())
		{
			this.givenName = pn.getGivenName();
			this.familyName = pn.getFamilyName();
			if(pn.getPreferred())
				break;
		}
		this.gender = result.getGender();
		this.dateOfBirth = new SimpleDateFormat("yyyy-MMM-dd").format(result.getBirthdate());
		for(PatientIdentifier pid : result.getIdentifiers())
		{
			if(pid.getIdentifierType() == null)
				this.ecid = pid.getIdentifier();
			else if(this.identifier == null)
				this.identifier = String.format("%s (%s)", pid.getIdentifier(), pid.getIdentifierType().getDescription());
			else if(pid.getPreferred())
			{
				this.identifier = String.format("%s", pid.getIdentifier());
			}
			
			//this.isImported |= pid.getIdentifierType().getName().equals(this.m_configuration.getPatientRoot());
		}
		
		Patient matchedPatient = Context.getService(MpiClientService.class).matchWithExistingPatient(result);
		if(matchedPatient != null)
		{
			this.isImported = true;
			this.openMrsId = matchedPatient.getId();
		}
	}
	
}
