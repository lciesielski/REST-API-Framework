@IsTest
private class UserApiExternalIntegrationTest {

	@testSetup
	private static void setup() {
		update new User(Id = UserInfo.getUserId(), IsEmployee__c = true);
	}

	@IsTest
	private static void itShouldGetUserWithSpecifiedEmployeeCustomField() {
		// Given
		final Set<String> responseWrapperTypes = new Set<String>();
		final Integer expectedMinimalUserCount = 1;
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String>{
			RestApiBase.ContextParameter.context.name() => 
				UserRestApi.AllowedIntegration.EXTERNAL.name(),
			UserApiExternalIntegration.WhereBoolEqualsQueryParameter.isEmployeeCustomField.name() => 
				'true'
		});

		// When
		final RestApiSuccessResult result = (RestApiSuccessResult) UserRestApi.getUserDetails();

		// Then
		for (Type wrapperType : result.items.keySet()) {
			responseWrapperTypes.add(wrapperType.getName());
		}

		System.assert(
			result.items.containsKey(UserApiExternalIntegration.UserWrapper.class), 
			String.format(
				Label.ResponseTypeAssertFailure, 
				new List<String>{JSON.serialize(responseWrapperTypes)}
			)
		);
		System.assert(
			expectedMinimalUserCount <= result.totalSize, 
			String.format(
				Label.RecordCountMismatch, 
				new List<String>{
					String.valueOf(expectedMinimalUserCount), 
					String.valueOf(result.totalSize)
				}
			)
		);
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
		final UserApiExternalIntegration userInternalIntegration = 
			new UserApiExternalIntegration();

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