# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class BayesXSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system *args
    super *args + ['--username', 'anonymous',  '--password', '', '--no-auth-cache', '--non-interactive', '--trust-server-cert']
  end
end

class Bayesx < Formula
  homepage "http://www.bayesx.org"
  url "http://www.statistik.lmu.de/~bayesx/install/bayesxsource_3_0_1.zip"
  version "3.0.1"
  sha256 "fd4b2321b0aed78d4dab70a25d3deb609ef5e5cbfb37317540b63b153c4e0b38"

  head "https://svn.gwdg.de/svn/bayesx/trunk", :using => BayesXSvnStrategy

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "readline"

  option "with-java", "Enable java support"

  def install
    args = ["-DWithoutDefaultOs=On"] + std_cmake_args
    unless build.with? "java"
      args.push("-DWithoutJava=On")
    end
    system "cmake", ".", *args
    system "make", "bayesx"
    bin.install "bayesx"

    if build.head?
      prefix.install "sourcecode/LICENSE"
    else
      prefix.install "LICENSE"
    end

  end

  test do
    # TODO
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test bayesx`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
