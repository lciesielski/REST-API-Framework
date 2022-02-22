@IsTest
private class RestApiBaseTest {

	@IsTest
	private static void itShouldCheckForExistingParameter() {
		// Given
		final String parameter = 'Test';
		Boolean result;

		// When
		result = RestApiBase.isParamPresent(parameter);

		// Then
		System.assertEquals(false, result);

		// Given
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String> {
			parameter => parameter
		});

		// When
		result = RestApiBase.isParamPresent(parameter);

		// Then
		System.assertEquals(true, result);
	}

	@IsTest
	private static void itShouldCheckForParameterValue() {
		// Given
		final String parameter = 'Test';
		final String parameterValue = 'true';
		String result;

		// When
		result = RestApiBase.getParamSafe(parameter);

		// Then
		System.assert(
			String.isBlank(result), 
			String.format(Label.IncorrectValue, new List<String>{'', result})
		);

		// Given
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String> {
			parameter => parameterValue
		});

		// When
		result = RestApiBase.getParamSafe(parameter);

		// Then
		System.assertEquals(parameterValue, result);
	}

	@IsTest
	private static void itShouldCheckIfParamaterIsTrue() {
		// Given
		final String parameter = 'Test';
		final String parameterValue = 'true';
		Boolean result;

		// When
		result = RestApiBase.isParamTrue(parameter);

		// Then
		System.assert(
			!result, 
			String.format(
				Label.IncorrectValue, 
				new List<String>{'false', String.valueOf(result)}
			)
		);

		// Given
		RestApiTestBase.setRestContextRequestWithParams(new Map<String, String> {
			parameter => parameterValue
		});

		// When
		result = RestApiBase.isParamTrue(parameter);

		// Then
		System.assert(
			result, 
			String.format(
				Label.IncorrectValue, 
				new List<String>{'true', String.valueOf(result)}
			)
		);
	}

}