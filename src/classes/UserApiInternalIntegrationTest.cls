@IsTest
private class UserApiInternalIntegrationTest {

	@IsTest
	private static void itShouldGetUserWithSpecifiedUsername() {
		// Given
		final Set<String> responseWrapperTypes = new Set<String>();
		final Integer expectedUserCount = 1;
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String>{
			RestApiBase.ContextParameter.context.name() => 
				UserRestApi.AllowedIntegration.INTERNAL.name(),
			UserApiInternalIntegration.WhereStringEqualsQueryParameter.username.name() => 
				UserInfo.getUserName(),
			UserApiInternalIntegration.WhereStringEqualsQueryParameter.email.name() => 
				UserInfo.getUserEmail()
		});

		// When
		final RestApiSuccessResult result = (RestApiSuccessResult) UserRestApi.getUserDetails();

		// Then
		for (Type wrapperType : result.items.keySet()) {
			responseWrapperTypes.add(wrapperType.getName());
		}

		System.assert(
			result.items.containsKey(UserRestApi.UserWrapper.class), 
			String.format(
				Label.ResponseTypeAssertFailure, 
				new List<String>{JSON.serialize(responseWrapperTypes)}
			)
		);
		System.assertEquals(expectedUserCount, result.totalSize);
	}

	@IsTest
	private static void itSohuldHandleInvalidIntegrationError() {
		// Given
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String>{
			RestApiBase.ContextParameter.context.name() => 'INVALID'
		});
		RestContext.response = new RestResponse();

		// When
		final RestApiErrorResult result = (RestApiErrorResult) UserRestApi.getUserDetails();

		// Then
		System.assertEquals(
			ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_ERROR_CODE.get(
				ExceptionUtils.IntegrationNotAllowedException.class.getName()
			),
			result.errorCode
		);
	}

	@IsTest
	private static void itShouldRejectUnimplementedMethods() {
		// Given
		final UserApiInternalIntegration userInternalIntegration = 
			new UserApiInternalIntegration();

		// When
		try {
			userInternalIntegration.postLogic();
			System.assert(false, Label.ExpectedException);
		} catch (ExceptionUtils.MethodNotImplementedException ex) {
			// Then
			System.assertEquals(Label.MethodNotImplemented, ex.getMessage());
		}

		// When
		try {
			userInternalIntegration.putLogic();
			System.assert(false, Label.ExpectedException);
		} catch (ExceptionUtils.MethodNotImplementedException ex) {
			// Then
			System.assertEquals(Label.MethodNotImplemented, ex.getMessage());
		}

		// When
		try {
			userInternalIntegration.deleteLogic();
			System.assert(false, Label.ExpectedException);
		} catch (ExceptionUtils.MethodNotImplementedException ex) {
			// Then
			System.assertEquals(Label.MethodNotImplemented, ex.getMessage());
		}
	}

}