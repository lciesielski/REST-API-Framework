@isTest
public class RestApiTestBase {

	public static void setRestContextRequestWithParams(Map<String, String> params) {
		final RestRequest request = new RestRequest();
		for (String key : params.keySet()) {
			request.params.put(key, params.get(key));
		}
		RestContext.request = request;
	}

}