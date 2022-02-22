public virtual class RestApiSuccessResult extends RestApiResult {

	private final Boolean success = true;

	@TestVisible
	protected Map<Type, List<ResultItem>> items;

	@TestVisible
	protected Integer totalSize {
		get {
			Integer result = 0; 
			for (Type key : items.keySet()) {
				result += items.get(key).size(); 
			}
			return result;
		}
	}

	public RestApiSuccessResult() {
		this.items = new Map<Type, List<ResultItem>>();
	}

	public void addToResult(Type wrapperType, ResultItem wrapperObject) {
		if (items.containsKey(wrapperType)) {
			items.get(wrapperType).add(wrapperObject);
		} else {
			items.put(wrapperType, new List<ResultItem>{wrapperObject});
		}
	}

	public virtual class ResultItem {
		@TestVisible
		protected Boolean checkForPopulatedField(Set<String> populatedFieldNames, SObjectField field) {
			return populatedFieldNames.contains(field.getDescribe().getName());
		}

		public virtual ResultItem initialize(Object item) {
			throw new ExceptionUtils.MethodNotImplementedException(Label.MethodNotImplemented);
		}
	}

}