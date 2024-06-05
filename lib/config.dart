String getServerUrl() {
  const bool isDebug = !bool.fromEnvironment('dart.vm.product');
  if (isDebug) {
    //la IP de la máquina local
    return 'http://192.168.1.101:8080';
  } else {
    // URL del servidor en producción
    return 'https://tuservidor.com';
  }
}
