public virtual class RestApiErrorResult extends RestApiResult {

	private final Boolean success = false;

	private String errorCode;
	private String message;

	public RestApiErrorResult(Exception ex) {
		this.errorCode = ExceptionUtils.EXCEPTION_TO_REST_RESPONSE_ERROR_CODE.get(ex.getTypeName());
		this.message = ex.getMessage();
	}

	public RestApiErrorResult(String errorCode, String msg) {
		this.errorCode = errorCode;
		this.message = msg;
	}
	
}