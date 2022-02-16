@RestResource(urlMapping='/v1/users')
global with sharing class UserRestApi {

	public enum AvailableParameters {
		isActive
	}

	@HttpGet
	@ReadOnly
	WebService static RestApiResult getUserDetails() {
		try {
			if (RestApiUtils.isParamPresent(AvailableParameters.isActive.name())) {
				return new UserListWrapper([
					SELECT Id 
					FROM User 
					WHERE IsActive = :RestApiUtils.isParamTrue(AvailableParameters.isActive.name())
				]);
			} else {
				return new UserListWrapper([SELECT Id FROM User]);
			}
		} catch (Exception ex) {
			LogUtils.error(UserRestApi.class, ex);
			return new RestApiErrorResult(ex);
		}
	}

	@TestVisible
	private class UserListWrapper extends RestApiSuccessResult {
		public UserListWrapper(List<User> users) {
			super();

			for (User user : users) {
				addToResult(UserWrapper.class, new UserWrapper(user));
			}
		}
	}

	public class UserWrapper extends RestApiSuccessResult.ResultItem {
		@TestVisible
		Id id;
		
		@TestVisible
		Boolean isActive;

		@TestVisible
		String email;
		@TestVisible
		String name;
		@TestVisible
		String username;

		@TestVisible
		private UserWrapper() {
			LogUtils.debug(UserRestApi.class, 'Unit test constructor executed');
		}

		public UserWrapper(User user) {
			this.id = user.Id;
			this.email = user.Email;
			this.name = user.Name;
			this.username = user.Username;
		}
	}

}