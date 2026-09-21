abstract class SplashEvent {
  const SplashEvent();
}

class SplashStartedEvent extends SplashEvent {
  const SplashStartedEvent();
}

class SplashRetriedEvent extends SplashEvent {
  const SplashRetriedEvent();
}
