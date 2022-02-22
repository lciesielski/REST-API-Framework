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
					return new UserListWrapper(
						new UserQueryConstrutor()
							.addToFieldSet(User.Email)
							.addToFieldSet(User.Username)
							.executeQuery()
					);
				}
				when EXTERNAL {
					if (RestApiBase.isParamPresent(WhereEqualsQueryParameter.username.name())) {
						throw new ExceptionUtils.IntegrationNotAllowedException(
							'You cannot specify username'
						);
					}

					return new UserListWrapper(
						new UserQueryConstrutor()
							.addToFieldSet(User.IsEmployee__c)
							.executeQuery()
						);
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

	private without sharing class UserQueryConstrutor extends RestApiBase.GetQueryConstructor {
		public UserQueryConstrutor() {
			super();

			super.contextSObjectDescription = User.SObjectType.getDescribe();
			super.queryFieldSet = new Set<SObjectField> {
				User.IsActive, 
				User.Name
			};
		}

		public List<User> executeQuery() {
			return (List<User>) Database.query(this.constructQueryFromFieldSet());
		}

		public UserQueryConstrutor addToFieldSet(SObjectField userField) {
			super.queryFieldSet.add(userField);
			return this;
		}

		public UserQueryConstrutor removeFromFieldSet(SObjectField userField) {
			super.queryFieldSet.remove(userField);
			return this;
		}

		protected override String constructQueryFromFieldSet() {
			String query = super.constructQueryFromFieldSet();

			if (RestApiBase.isParamPresent(UserRestApi.WhereEqualsQueryParameter.isActive.name())) {
				query += whereBooleanEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameter.isActive.name(), 
					getParamSafe(UserRestApi.WhereEqualsQueryParameter.isActive.name())
				);
			}

			if (RestApiBase.isParamPresent(UserRestApi.WhereEqualsQueryParameter.isEmployeeCustomField.name())) {
				query += whereBooleanEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameter.isEmployeeCustomField.name(), 
					getParamSafe(UserRestApi.WhereEqualsQueryParameter.isEmployeeCustomField.name())
				);
			}

			if (RestApiBase.isParamPresent(UserRestApi.WhereEqualsQueryParameter.Username.name())) {
				query += whereStringEquals(
					query, 
					UserRestApi.WhereEqualsQueryParameter.Username.name(), 
					getParamSafe(UserRestApi.WhereEqualsQueryParameter.Username.name())
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
		Boolean isEmployee;

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
			final Set<String> populatedFieldNames = user.getPopulatedFieldsAsMap().keySet();

			this.id = checkForPopulatedField(populatedFieldNames, Schema.User.Id) ? user.Id : null;
			this.isActive = checkForPopulatedField(populatedFieldNames, Schema.User.IsActive) ? user.IsActive : null;
			this.isEmployee = checkForPopulatedField(populatedFieldNames, Schema.User.IsEmployee__c) ? user.IsEmployee__c : null;
			this.email = checkForPopulatedField(populatedFieldNames, Schema.User.Email) ? user.Email : null;
			this.name = checkForPopulatedField(populatedFieldNames, Schema.User.Name) ? user.Name : null;
			this.username = checkForPopulatedField(populatedFieldNames, Schema.User.Username) ? user.Username : null;
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