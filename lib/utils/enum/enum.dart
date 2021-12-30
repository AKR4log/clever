enum AuthStatus {
  NOT_DETERMINED,
  AUTO_RETRIEVAL_TIMEOUT,
  CODE_SEND,
  REGISTER_NOW_USER,
  CODE_ERROR,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
enum PlayerState { stopped, playing, paused }
enum SupportState {
  on,
  unknown,
  supported,
  unsupported,
}
