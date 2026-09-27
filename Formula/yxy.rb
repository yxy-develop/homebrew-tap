# The yxy compiler and toolchain, built from source.
#
# From source, as the Arandu tap does: the compiler has no third-party crates,
# so the build needs only the Rust toolchain, and there is no per-platform
# binary to publish, sign or keep in step with a tag.
#
# While the yxy-develop repositories are private, the source comes over git
# with the installing user's own GitHub credentials, pinned to a tag and to its
# commit. When the repositories open, this becomes a release tarball with a
# sha256, like the Arandu formula.
class Yxy < Formula
  desc "Compiler and toolchain for the Yxy programming language"
  homepage "https://yxy.dev"
  url "git@github.com:yxy-develop/yxy.git",
      tag:      "v0.0.1",
      revision: "0000000000000000000000000000000000000000"
  license "BSD-3-Clause"
  head "git@github.com:yxy-develop/yxy.git", branch: "develop"

  depends_on "rust" => :build

  # yxy compiles through clang. macOS provides it with the Command Line Tools;
  # on Linux the llvm formula provides it, outside PATH.
  on_linux do
    depends_on "llvm"
  end

  def install
    system "cargo", "install", *std_cargo_args(root: libexec, path: "compiler")
    if OS.linux?
      (bin/"yxy").write_env_script libexec/"bin/yxy", YXY_CC: Formula["llvm"].opt_bin/"clang"
    else
      bin.install_symlink libexec/"bin/yxy"
    end
  end

  def caveats
    on_linux do
      <<~EOS
        On Linux, yxy checks programs and emits object files; linking and
        running executables on Linux is not supported yet (see
        docs/implementation/TARGETS.md in the yxy repository).
      EOS
    end
  end

  test do
    # The version comes from the build, so a stale tag in this file shows here.
    assert_match "yxy #{version}", shell_output("#{bin}/yxy --version")

    (testpath/"hello.yxy").write <<~YXY
      package hello

      fn main() -> u8
      effects {}
      {
          return 42
      }
    YXY
    system bin/"yxy", "check", "hello.yxy"

    if OS.mac?
      # The first thing anyone does after installing: build and run a program.
      system bin/"yxy", "build", "hello.yxy", "-o", "hello"
      shell_output("./hello", 42)
    else
      system bin/"yxy", "build", "hello.yxy", "--emit=obj", "-o", "hello.o"
      assert_path_exists testpath/"hello.o"
    end
  end
end
