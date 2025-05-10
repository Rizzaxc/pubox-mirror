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
    this.passwordLengthError = 'Password tối thiểu 8 ký tự',
    this.signIn = 'Đăng nhập',
    this.signUp = 'Đăng ký',
    this.forgotPassword = 'Quên password?',
    this.dontHaveAccount = 'Không có tài khoản? Đăng ký',
    this.haveAccount = 'Đã có tài khoản? Đăng nhập',
    this.sendPasswordReset = 'Gửi email reset password',
    this.passwordResetSent = 'Password reset email has been sent',
    this.backToSignIn = 'Quay về Đăng nhập',
    this.unexpectedError = 'An unexpected error occurred',
    this.requiredFieldError = 'This field is required',
    this.confirmPasswordError = 'Passwords không khớp',
    this.confirmPassword = 'Confirm Password',
  });
}
