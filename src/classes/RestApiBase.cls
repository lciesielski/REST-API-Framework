public without sharing virtual class RestApiBase {

	public interface Integration {
		Object validateContext();
	}

	public interface IntegrationItem {
		RestApiResult getLogic();
		RestApiResult postLogic();
		RestApiResult putLogic();
		RestApiResult deleteLogic();
	}

	public static Boolean isParamPresent(String key) {
		return 
			RestContext.request != null &&
			RestContext.request.params != null && 
			RestContext.request.params.containsKey(key);
	}

	public static String getParamSafe(String key) {
		if (!isParamPresent(key)) {
			return '';
		} else {
			return RestContext.request.params.get(key);
		}
	}

	public static Boolean isParamTrue(String key) {
		return 'true'.equalsIgnoreCase(getParamSafe(key));
	}

	public static RestApiErrorResult handleException(Type context, Exception ex, Savepoint systemSavepoint) {
		LogUtils.error(context, ex);

		if (systemSavepoint != null) {
			Database.rollback(systemSavepoint);
		}

		return new RestApiErrorResult(ex);
	}

	public without sharing virtual class GetQueryConstructor {

		protected DescribeSObjectResult contextSObjectDescription;
		protected Set<SObjectField> queryFieldSet;

		protected virtual String constructQueryFromFieldSet() {
			String query = 'SELECT ';

			for (SObjectField field : queryFieldSet) {
				query += field.getDescribe(FieldDescribeOptions.FULL_DESCRIBE).getName() + ',';
			}

			query = query.removeEnd(',');
			query += ' FROM ' + contextSObjectDescription.getName();

			return query;
		}

		protected String whereBooleanEquals(String query, String fieldName, String fieldValue) {
			String filter = checkForWhereClause(query);
			filter += replaceCustomFieldParamSuffix(fieldName) + '=' + fieldValue;

			return filter;
		}

		protected String whereStringEquals(String query, String fieldName, String fieldValue) {
			String filter = checkForWhereClause(query);
			filter += replaceCustomFieldParamSuffix(fieldName) + '=' + encloseInQuotes(fieldValue);

			return filter;
		}

		private String checkForWhereClause(String query) {
			if (!query.contains('WHERE')) {
				return ' WHERE ';
			} else {
				return ' AND ';
			}
		}

		private String replaceCustomFieldParamSuffix(String fieldName) {
			return fieldName.replace('CustomField', '__c');
		}

		private String encloseInQuotes(String fieldName) {
			return '\'' + fieldName + '\'';
		}

	}

}