// npx gulp build
function build(cb) {
  // place code for your default task here
  console.log("test");

  cb();  // タスクの最後に必要
}

// npx gulp hoge で実行可能 (exports.hoge に対して)
exports.build = build;

// デフォルトタスク: npx gulp のみで実行可能
exports.default = build;