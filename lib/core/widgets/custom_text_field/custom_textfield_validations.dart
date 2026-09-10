class CustomTextfieldValidations {
  static String? validateEmptyField(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  static String? validateFirstName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return validateEmptyField(value);
    }

    if (text.length > 64) {
      return 'First name must not exceed 64 characters';
    }

    return null;
  }

  static String? validateLastName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return validateEmptyField(value);
    }

    if (text.length > 64) {
      return 'Last name must not exceed 64 characters';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return validateEmptyField(value);
    }

    if (phone.length < 9) {
      return 'Phone number must be at least 9 digits';
    }

    if (phone.length > 32) {
      return 'Phone number must not exceed 32 characters';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return validateEmptyField(value);
    }

    if (email.length > 256) {
      return 'Email must not exceed 256 characters';
    }

    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return validateEmptyField(value);
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (password.length > 128) {
      return 'Password must not exceed 128 characters';
    }

    return null;
  }
}
