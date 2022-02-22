@RestResource(urlMapping='/v1/users')
global without sharing class UserRestApi implements RestApiBase.Integration {

	@testVisible
	private enum AllowedIntegration {
		INTERNAL,
		EXTERNAL
	}

	@testVisible
	private enum ContextParameter {
		context
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
						Label.IntegrationNotAllowed
					);
				}
				when else {
					throw new UnexpectedException(Label.UnexpectedException);
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