public virtual class RestApiErrorResult extends RestApiResult {

	private final Boolean success = false;

	@TestVisible
	private String errorCode;
	private String message;

	public RestApiErrorResult(Exception ex) {
		if (!ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_ERROR_CODE.containsKey(ex.getTypeName()) || 
			!ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_STATUS_CODE.containsKey(ex.getTypeName())
		) {
			this.errorCode = 'UNEXPECTED';
			this.message = ex.getMessage();
			RestContext.response.statusCode = 500;
		} else {
			this.errorCode = ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_ERROR_CODE.get(ex.getTypeName());
			this.message = ex.getMessage();
			RestContext.response.statusCode = ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_STATUS_CODE.get(ex.getTypeName());
		}
	}

}