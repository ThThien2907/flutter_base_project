enum ShellTab { home, settings }

abstract class ShellEvent {
  const ShellEvent();
}

class ShellStartedEvent extends ShellEvent {
  const ShellStartedEvent();
}

class ShellTabChangedEvent extends ShellEvent {
  const ShellTabChangedEvent(this.tab);

  final ShellTab tab;
}
