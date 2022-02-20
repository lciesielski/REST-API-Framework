public without sharing class RestApiUtils {

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

	public virtual class GetQueryConstructor {

		protected DescribeSObjectResult contextSObjectDescription;
		protected Set<SObjectField> fieldSet;

		protected virtual String constructQueryFromFieldSet() {
			String query = 'SELECT ';

			for (SObjectField field : fieldSet) {
				query += field.getDescribe(FieldDescribeOptions.FULL_DESCRIBE).getName() + ',';
			}

			query = query.removeEnd(',');
			query += ' FROM ' + contextSObjectDescription.getName();

			return query;
		}

		protected virtual String whereEquals(String query, String fieldName, String fieldValue) {
			String filter = '';

			if (!query.contains('WHERE')) {
				filter += ' WHERE ';
			}

			filter += fieldName + '=' + fieldValue;

			return filter;
		}

	}

}