@RestResource(urlMapping='/v1/users')
global without sharing class UserRestApi implements RestApiBase.Integration {

	private enum AllowedIntegration {
		INTERNAL,
		EXTERNAL
	}

	private enum ContextParameter {
		context
	}

	private enum WhereEqualsQueryParameter {
		isActive,
		isEmployeeCustomField,
		username
	}

	@HttpGet
	@ReadOnly
	WebService static RestApiResult getUserDetails() {
		try {
			switch on (AllowedIntegration) validateContext() {
				when INTERNAL {
					return new UserApiInternalIntegration().getLogic();
				}
				when EXTERNAL {
					return new UserApiExternalIntegration().getLogic();
				}
				when null {
					throw new ExceptionUtils.IntegrationNotAllowedException(
						'Integration is not allowed for this endpoint.'
					);
				}
				when else {
					throw new UnexpectedException(
						'Unexpected exception.'
					);
				}
			}
		} catch (Exception ex) {
			return RestApiBase.handleException(UserRestApi.class, ex, null);
		}
	}

	public class UserListWrapper extends RestApiSuccessResult {
		public UserListWrapper(List<User> users, Type wrapperType) {
			super();

			for (User user : users) {
				addToResult(
					wrapperType, 
					((RestApiSuccessResult.ResultItem) wrapperType.newInstance()).initialize(user)
				);
			}
		}
	}

	public static Object validateContext() {
		final String contextParameterValue = RestApiBase.getParamSafe(ContextParameter.context.name());
		
		for (AllowedIntegration integration : AllowedIntegration.values()) {
			if (contextParameterValue == integration.name()) {
				return integration;
			}
		}

		return null;
	}

}