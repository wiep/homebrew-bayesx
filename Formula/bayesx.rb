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

  patch do
    url "https://raw.githubusercontent.com/wiep/homebrew-bayesx/master/patch/EOF-bug.patch"
    sha256 "00f868d7885b25630b3bb47e16c80d0ad7740be932ce91e4d8dc72932303d865"
  end

  unless build.with? "java"
    patch do
      url "https://raw.githubusercontent.com/wiep/homebrew-bayesx/master/patch/disable-java.patch"
      sha256 "83833da1833db6b79a478db40bee31a4209d1adf06adbe164d35d2063117f36e"
    end
  end

#  head do
#    patch do
#      url "https://raw.githubusercontent.com/wiep/homebrew-bayesx/master/patch/bayesx-eof-svnrevision.diff"
#      sha256 "1977e4f15ec0ba66d0d52fbabe7580d918f3d8b2c754d78cd57179d0899dbe54"
#    end
#  end

  def install
    system "cmake", ".", *std_cmake_args
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
