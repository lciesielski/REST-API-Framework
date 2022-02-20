public virtual class RestApiSuccessResult extends RestApiResult {

	private final Boolean success = true;

	protected Map<Type, List<ResultItem>> items;

	protected Integer totalSize {
		get {
			Integer result = 0; 
			for (Type key : items?.keySet()) {
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

	public abstract class ResultItem {}
	
}