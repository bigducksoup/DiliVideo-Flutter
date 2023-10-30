




// typedef GenericFunctionProxy = dynamic Function(List<dynamic>);

// // 原始函数
// void originalFunction(int a, String b) {
//   print('调用了原始函数，参数值为: $a, $b');
// }

// // 代理函数
// dynamic proxyFunction(GenericFunctionProxy original, List<dynamic> args) {
//   print('在代理函数中执行一些额外的操作');
//   var result = original(args);
//   print('在代理函数中执行一些额外的操作');
//   return result;
// }

// void main() {
//   // 创建代理函数
//   var proxy = (List<dynamic> args) {
//     proxyFunction(originalFunction, args);
//   };

//   // 调用代理函数
//   proxy([42, "Hello"]);
// }