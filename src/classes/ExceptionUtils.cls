public without sharing class ExceptionUtils {

	public static final Map<String, String> EXCEPTION_TO_REST_RESPONSE_ERROR_CODE = new Map<String, String> {
		RequiredParameterMissingException.class.getName() => 'REQUIRED_PARAM_MISSING',
		IntegrationNotAllowedException.class.getName() => 'INTEGRATION_NOT_ALLOWED',
		MethodNotImplementedException.class.getName() => 'METHOD_NOT_IMPLEMENTED'
	};

	public static final Map<String, Integer> EXCEPTION_TO_REST_RESPONSE_STATUS_CODE = new Map<String, Integer> {
		RequiredParameterMissingException.class.getName() => 400,
		IntegrationNotAllowedException.class.getName() => 403,
		MethodNotImplementedException.class.getName() => 501
	};

	public class RequiredParameterMissingException extends Exception {}
	public class IntegrationNotAllowedException extends Exception {}
	public class MethodNotImplementedException extends Exception {}

}