@isTest
private class RestApiResultTest {

	@isTest
	private static void itShouldHandleExpectedException() {
		// Given
		RestContext.response = new RestResponse();
		final ExceptionUtils.RequiredParameterMissingException knownException = 
			new ExceptionUtils.RequiredParameterMissingException();

		// When
		final RestApiErrorResult result = new RestApiErrorResult(knownException);

		// Then
		System.assertEquals(
			ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_ERROR_CODE.get(
				knownException.getTypeName()
			), 
			result.errorCode
		);
		System.assertEquals(
			ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_STATUS_CODE.get(
				knownException.getTypeName()
			), 
			RestContext.response.statusCode
		);
	}

	@isTest
	private static void itShouldHandleUnexpectedException() {
		// Given
		RestContext.response = new RestResponse();
		final LimitException unexpectedException = new LimitException();

		// When
		final RestApiErrorResult result = new RestApiErrorResult(unexpectedException);

		// Then
		System.assertEquals(
			'UNEXPECTED', 
			result.errorCode
		);
		System.assertEquals(
			500,
			RestContext.response.statusCode
		);
	}

	@isTest
	private static void itSohuldTestSuccessResult() {
		// Given
		final RestApiSuccessResult successResult = new RestApiSuccessResult();
		final RestApiSuccessResult.ResultItem successResultItem = new RestApiSuccessResult.ResultItem();

		// When
		Boolean result = successResultItem.checkForPopulatedField(
			new Set<String>{
				Schema.User.Name.getDescribe().getName()
			}, 
			Schema.User.Email
		);

		// Then
		System.assert(
			!result, 
			new List<String>{'false', String.valueOf(result)}
		);

		// When
		result = successResultItem.checkForPopulatedField(
			new Set<String>{
				Schema.User.Name.getDescribe().getName()
			}, 
			Schema.User.Name
		);

		// Then
		System.assert(
			result, 
			new List<String>{'true', String.valueOf(result)}
		);

		// Given
		final Integer expectedItemsSize = 2;

		// When
		successResult.addToResult(RestApiResultTest.class, successResultItem);
		successResult.addToResult(RestApiResultTest.class, successResultItem);

		// Then
		System.assertEquals(expectedItemsSize, successResult.totalSize);
	}

}