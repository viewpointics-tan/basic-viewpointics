const glob = require('glob');
const exec = require('child_process').exec;

// npx gulp build
function build(cb) {

  glob('src/**/*.md', (err, files) => {
    for (const file of files) {
      exec("echo " + file, (err, stdout, stderr) => {
        cb(err);
        console.log(stdout);
      })
    }
  })

  // const command = "pandoc --version";
  // exec(command, (err, stdout, stderr) => {
  //   console.log(stdout);
  //   cb(err);
  // })

  cb();  // タスクの最後に必要（正常終了）
}

// npx gulp hoge で実行可能 (exports.hoge に対して)
exports.build = build;

// デフォルトタスク: npx gulp のみで実行可能
exports.default = build;