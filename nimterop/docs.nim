import macros, strformat

when (NimMajor, NimMinor, NimPatch) >= (0, 19, 9):
  from os import parentDir
  proc getNimRootDir(): string =
    #[
    hack, but works
    alternatively (but more complex), use (from a nim file, not nims otherwise
    you get Error: ambiguous call; both system.fileExists):
    import "$nim/testament/lib/stdtest/specialpaths.nim"
    nimRootDir
    ]#
    fmt"{currentSourcePath}".parentDir.parentDir.parentDir

proc buildDocs*(files: seq[string], path: string, baseDir = getProjectPath() & "/") =
  ## Generate docs for all specified nim `files` to the specified `path`
  ##
  ## `baseDir` is the project path by default and `files` and `path` are relative
  ## to that directory. Set to "" if using absolute paths.
  ##
  ## Use the `--publish` flag with nimble to publish docs contained in
  ## `path` to Github in the `gh-pages` branch. This requires the ghp-import
  ## package for Python: `pip install ghp-import`
  ##
  ## WARNING: `--publish` will destroy any existing content in this branch.
  let
    path = baseDir & path
  for file in files:
    echo gorge(&"nim doc -o:{path} --project --index:on {baseDir & file}")

  echo gorge(&"nim buildIndex -o:{path}/theindex.html {path}")
  when declared(getNimRootDir):
    #[
    this enables doc search, works at least locally with:
    cd {path} && python -m SimpleHTTPServer 9009
    ]#
    echo gorge(&"nim js -o:{path}/dochack.js {getNimRootDir()}/tools/dochack/dochack.nim")

  for i in 0 .. paramCount():
    if paramStr(i) == "--publish":
      echo gorge(&"ghp-import --no-jekyll -fp {path}")
      break
