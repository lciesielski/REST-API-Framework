public without sharing class LogUtils {

	@SuppressWarnings('PMD.AvoidDebugStatements')
	public static void debug(Type context, String message) {
		System.debug(LoggingLevel.INFO, buildDebugMessage(context, message));
	}

	@SuppressWarnings('PMD.AvoidDebugStatements')
	public static void error(Type context, Exception ex) {
		System.debug(LoggingLevel.ERROR, buildErrorMessage(context, ex));
	}

	@TestVisible
	private static String buildDebugMessage(Type context, String message) {
		return context.getName() + '\n' + 'Message --- ' + message;
	}

	@TestVisible
	private static String buildErrorMessage(Type context, Exception ex) {
		return context.getName() + '\n' +
			'Exception message --- ' + ex.getMessage() + '\n' + 
			'Exception line no --- ' + ex.getLineNumber() + '\n' + 
			'Exception stack --- ' + ex.getStackTraceString();
	}

}