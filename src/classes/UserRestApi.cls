@RestResource(urlMapping='/v1/users')
global with sharing class UserRestApi {

	public enum WhereEqualsQueryParameters {
		isActive,
		isEmployeeCustomField,
		username
	}

	@HttpGet
	@ReadOnly
	WebService static RestApiResult getUserDetails() {
		try {
			if (RestApiUtils.isParamPresent(WhereEqualsQueryParameters.isActive.name())) {
				return new UserListWrapper(new UserQueryConstrutor().executeQuery());
			} else {
				throw new ExceptionUtils.RequiredParameterMissingException(
					'Required parameter missing ' + WhereEqualsQueryParameters.isActive.name()
				);
			}
		} catch (Exception ex) {
			return RestApiUtils.handleException(UserRestApi.class, ex, null);
		}
	}

	private class UserQueryConstrutor extends RestApiUtils.GetQueryConstructor {
		public UserQueryConstrutor() {
			super();

			this.contextSObjectDescription = User.SObjectType.getDescribe();
			this.fieldSet = new Set<SObjectField> {
				User.Email, 
				User.IsActive, 
				User.Name,
				User.Username
			};
		}

		public List<User> executeQuery() {
			return (List<User>) Database.query(this.constructQueryFromFieldSet());
		}

		public override String constructQueryFromFieldSet() {
			String query = super.constructQueryFromFieldSet();

			if (RestApiUtils.isParamPresent(UserRestApi.WhereEqualsQueryParameters.isActive.name())) {
				query += whereBooleanEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameters.isActive.name(), 
					RestApiUtils.getParamSafe(UserRestApi.WhereEqualsQueryParameters.isActive.name())
				);
			}

			if (RestApiUtils.isParamPresent(UserRestApi.WhereEqualsQueryParameters.isEmployeeCustomField.name())) {
				query += whereBooleanEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameters.isEmployeeCustomField.name(), 
					RestApiUtils.getParamSafe(UserRestApi.WhereEqualsQueryParameters.isEmployeeCustomField.name())
				);
			}

			if (RestApiUtils.isParamPresent(UserRestApi.WhereEqualsQueryParameters.Username.name())) {
				query += whereStringEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameters.Username.name(), 
					RestApiUtils.getParamSafe(UserRestApi.WhereEqualsQueryParameters.Username.name())
				);
			}

			return query;
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
			this.isActive = user.IsActive;
			this.email = user.Email;
			this.name = user.Name;
			this.username = user.Username;
		}
	}

}