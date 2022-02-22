@IsTest
private class LogUtilsTest {

	@IsTest
	private static void itShouldLogDebugMessage() {
		// Given
		final String message = 'Test Message';
		
		// When
		LogUtils.debug(LogUtilsTest.class, message);
		final String debugMessage = LogUtils.buildDebugMessage(LogUtilsTest.class, message);

		// Then
		System.assert(
			debugMessage.startsWith(LogUtilsTest.class.getName()), 
			String.format(Label.IncorrectMessage, new List<String>{debugMessage})
		);
	}

	@IsTest
	private static void itShouldLogErrorMessage() {
		// Given
		final Exception ex = new ExceptionUtils.RequiredParameterMissingException();
		ex.setMessage('Test Exception');
		
		// When
		LogUtils.error(LogUtilsTest.class, ex);
		final String errorMessage = LogUtils.buildErrorMessage(LogUtilsTest.class, ex);

		// Then
		System.assert(
			errorMessage.startsWith(LogUtilsTest.class.getName()), 
			String.format(Label.IncorrectMessage, new List<String>{errorMessage})
		);
	}

}