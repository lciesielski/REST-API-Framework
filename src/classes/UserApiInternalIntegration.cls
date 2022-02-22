public without sharing class UserApiInternalIntegration implements RestApiBase.IntegrationItem {

	@testVisible
	private enum WhereStringEqualsQueryParameter {
		email,
		username
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
				User.Email,
				User.Name,
				User.Username
			};
		}

		public List<User> executeQuery() {
			return (List<User>) Database.query(this.constructQueryFromFieldSet());
		}

		protected override String constructQueryFromFieldSet() {
			String query = super.constructQueryFromFieldSet();

			for (UserApiInternalIntegration.WhereStringEqualsQueryParameter queryEqualsParameter : 
				UserApiInternalIntegration.WhereStringEqualsQueryParameter.values()
			) {
				if (RestApiBase.isParamPresent(queryEqualsParameter.name())) {
					query += whereStringEquals(
						query, 
						queryEqualsParameter.name(), 
						getParamSafe(queryEqualsParameter.name())
					);
				}
			}

			return query;
		}

	}

	@testVisible
	private class UserWrapper extends RestApiSuccessResult.ResultItem {
		@TestVisible
		Id id;

		@TestVisible
		String email;
		@TestVisible
		String name;
		@TestVisible
		String username;

		public override RestApiSuccessResult.ResultItem initialize(Object item) {
			final User user = (User) item;

			this.id = user.Id;
			this.email = user.Email;
			this.name = user.Name;
			this.username = user.Username;

			return this;
		}
	}

}