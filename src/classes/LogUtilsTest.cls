@IsTest
private class LogUtilsTest {

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
			'Error message is incorrect, actuall message : ' + errorMessage
		);
	}

}