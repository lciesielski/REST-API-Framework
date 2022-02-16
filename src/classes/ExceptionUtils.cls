public without sharing class ExceptionUtils {

	public static final Map<String, String> EXCEPTION_TO_REST_RESPONSE_ERROR_CODE = new Map<String, String> {
		RequiredParameterMissingException.class.getName() => 'REQUIRED_PARAM_MISSING'
	};

	public static final Map<String, Integer> EXCEPTION_TO_REST_RESPONSE_STATUS_CODE = new Map<String, Integer> {
		RequiredParameterMissingException.class.getName() => 400
	};

	public class RequiredParameterMissingException extends Exception {}

}