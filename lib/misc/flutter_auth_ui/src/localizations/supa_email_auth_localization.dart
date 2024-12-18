class SupaEmailAuthLocalization {
  final String enterEmail;
  final String validEmailError;
  final String enterPassword;
  final String passwordLengthError;
  final String signIn;
  final String signUp;
  final String forgotPassword;
  final String dontHaveAccount;
  final String haveAccount;
  final String sendPasswordReset;
  final String passwordResetSent;
  final String backToSignIn;
  final String unexpectedError;
  final String requiredFieldError;
  final String confirmPasswordError;
  final String confirmPassword;

  const SupaEmailAuthLocalization({
    this.enterEmail = 'Email',
    this.validEmailError = 'Email không hợp lệ',
    this.enterPassword = 'Password',
    this.passwordLengthError =
        'Password tối thiểu 8 ký tự',
    this.signIn = 'Sign In',
    this.signUp = 'Sign Up',
    this.forgotPassword = 'Forgot your password?',
    this.dontHaveAccount = 'Don\'t have an account? Sign up',
    this.haveAccount = 'Already have an account? Sign in',
    this.sendPasswordReset = 'Send password reset email',
    this.passwordResetSent = 'Password reset email has been sent',
    this.backToSignIn = 'Back to sign in',
    this.unexpectedError = 'An unexpected error occurred',
    this.requiredFieldError = 'This field is required',
    this.confirmPasswordError = 'Passwords do not match',
    this.confirmPassword = 'Confirm Password',
  });
}
