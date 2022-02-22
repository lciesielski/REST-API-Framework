public without sharing class UserApiExternalIntegration implements RestApiBase.IntegrationItem {

	@TestVisible
	private enum WhereBoolEqualsQueryParameter {
		isEmployeeCustomField
	}

	public RestApiResult getLogic() {
		return new UserRestApi.UserListWrapper(new UserQueryConstrutor().executeQuery(), UserWrapper.class);
	}

	public RestApiResult postLogic() {
		throw new ExceptionUtils.MethodNotImplementedException(Label.MethodNotImplemented);
	}

	public RestApiResult putLogic() {
		throw new ExceptionUtils.MethodNotImplementedException(Label.MethodNotImplemented);
	}

	public RestApiResult deleteLogic() {
		throw new ExceptionUtils.MethodNotImplementedException(Label.MethodNotImplemented);
	}

	private without sharing class UserQueryConstrutor extends RestApiBase.GetQueryConstructor {
		public UserQueryConstrutor() {
			super();

			super.contextSObjectDescription = User.SObjectType.getDescribe();
			super.queryFieldSet = new Set<SObjectField> {
				User.IsActive, 
				User.IsEmployee__c,
				User.Name
			};
		}

		public List<User> executeQuery() {
			return (List<User>) Database.query(this.constructQueryFromFieldSet());
		}

		protected override String constructQueryFromFieldSet() {
			String query = super.constructQueryFromFieldSet();

			for (UserApiExternalIntegration.WhereBoolEqualsQueryParameter queryEqualsParameter : 
				UserApiExternalIntegration.WhereBoolEqualsQueryParameter.values()
			) {
				if (RestApiBase.isParamPresent(queryEqualsParameter.name())) {
					query += whereBooleanEquals(
						query, 
						queryEqualsParameter.name(), 
						getParamSafe(queryEqualsParameter.name())
					);
				}
			}

			return query;
		}

	}

	@TestVisible
	private class UserWrapper extends RestApiSuccessResult.ResultItem {
		@TestVisible
		Id id;
		
		@TestVisible
		Boolean isActive;
		@TestVisible
		Boolean isEmployee;

		@TestVisible
		String name;

		public override RestApiSuccessResult.ResultItem initialize(Object item) {
			final User user = (User) item;
			
			this.id = user.Id;
			this.isActive = user.IsActive;
			this.isEmployee = user.IsEmployee__c;
			this.name = user.Name;

			return this;
		}
	}

}