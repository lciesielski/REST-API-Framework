public without sharing class RestApiUtils {

	public static Boolean isParamPresent(String key) {
		return 
			RestContext.request != null &&
			RestContext.request.params != null && 
			RestContext.request.params.containsKey(key);
	}

	public static String getParamSafe(String key) {
		if (!isParamPresent(key)) {
			return '';
		} else {
			return RestContext.request.params.get(key);
		}
	}

	public static Boolean isParamTrue(String key) {
		return 'true'.equalsIgnoreCase(getParamSafe(key));
	}
	
}