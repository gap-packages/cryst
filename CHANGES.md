## 4.1.32 (2026-08-18)

- fixed AffineNormalizer, which returned a proper subgroup of the affine
  normalizer for some space groups (e.g. Pc), because the stabilizer
  computation used incomplete Schreier generators
  (thanks to lan496 for reporting, and to fingolfin for fixing).

- converted manual to GAPDoc (thanks to fingolfin for the conversion)

## 4.1.31 (2026-05-04)

- fixed a bug in RepresentativeAction for affine cryst groups
  due to incorrect handling of empty list of point group generators
  (thanks to  kiryph for reporting).

## 4.1.30 (2025-09-22)

- fixed a regression in WyckoffPositions (thanks to kiryph for reporting).

## 4.1.29 (2025-07-18)

- fix an inconsistent numbering of stabilizer classes of WyckoffPositions
  (thanks to Bernard Field for analyzing and reporting)

- replaced an incorrect implementation of IsSymmorphicSpaceGroup by a
  correct one (thanks to Hongyi Zhao for analyzing and reporting)

## 4.1.28 (2025-07-17)

- standardized Wyckoff position representation, which is now stable
 across GAP versions

- adaptions to new treatment of rational matrix groups (we need
  the polenta package now)

## 4.1.27 (2023-12-18)

- fixed incomplete conjugation of Wyckoff positions
  (thanks to Bernard Field and Max Horn)

## 4.1.26 (2023-04-03)

- Bugfix in SolveInhomEquationsModZ
- Bugfix in comparison of affine cryst groups.
- Catch the case of a trivial point group in ConjugatorSpaceGroups.
- Corrected the documentation regarding conjugation of space groups.

## 4.1.25 (2022-07-29)

- Improved documentation conversion and formatting

## 4.1.24 (2021-05-25)

- Catch another trivial case in IntSolutionMat.
- Turn RowEchelonForm into an attribute, to make it read-only.
- Switch to GitHub Actions CI.
- Test CrystCat functionality only when CrystCat is available.

## 4.1.23 (2019-12-10)

- Make Cryst work at assertion level 2.

## 4.1.22 (2019-11-14)

- Adjustments due to name change from Carat to CaratInterface.

## 4.1.21 (2019-10-24)

- Make silent assumption on pcgs in MaximalSubgroupRepsSG explicit.
- Fixed bug in WyckoffPositions. Some Wyckoff positions were listed
  more than once, due to improper normalization of the representative
  affine subspace.

## 4.1.20 (2019-08-29)

- Catch trivial case before calling IsDiagonalMat

## 4.1.19 (2019-05-28)

- Compatibility fixes for GAP 4.11.

## 4.1.18 (2018-10-23)

- Fixed trivial changes in output of a manual example and several test examples.

## 4.1.17 (2018-04-13)

- Bug in ConjugatorSpaceGroups fixed.

## 4.1.16 (2018-03-01)

- Bug in ImagesRepresentative for isomorphism to PcpGroup fixed.
- Bug in kernel of PointHomomorphism for left-acting group fixed.
- Bugs in Centralizer and CanonicalRightCosetElement fixed.
- Test files with better code coverage.

## 4.1.15 (2018-02-09)

- PackageInfo record corrected

## 4.1.14 (2018-02-08)

- Corrected incompatible standardizations of affine subspaces.
- Added various testfiles.

## 4.1.13 (2017-12-22)

- Fixed a bug in ImagesRepresentative for IsFromAffineCrystGroupToPcpGroup

## 4.1.12 (2013-10-10)

- Fixed a bug in RepresentativeAction for AffineCrystGroups

## 4.1.11 (2013-01-10)

- Fixed a bug in the conjugation of left-acting AffineCrystGroups
- Changed outdated RequirePackage in manual

## 4.1.10 (2012-05-29)

- Fixed file permission problem

## 4.1.9 (2012-05-02)

- Minor Update

## 4.1.8

- Bugfix in AffineNormalizer

## 4.1.7

- Adapted to GAP 4.5

## 4.1.6

- TranslationBasis for trivial point group fixed
- Bug in ImagesRepresentative for IsomorphismFpGroup of an
  AffineCrystGroupOnLeft fixed
- Multiplication with empty matrix in WyckoffPositions fixed
- Membership test in AffineCrystGroups improved

## 4.1.5 (2007-08-28)

- Incomplete translation basis fixed

## 4.1.4

- Two instances of multiplying an empty list with a matrix fixed

## 4.1.3 (2004-04-21)

- Mutability problem fixed

## 4.1.2

- File manual.toc added

## 4.1.1 (2003-06-18)

- Online help should now work for all functions.

- Fixed several manual examples changed output or wrong input.

- Avoided some multiplications of an empty list with a matrix.

- Support for new package loading mechanism in GAP 4.4

## 4.1

- Name change from CrystGAP (or CrystGap) to just Cryst. This avoids
  confusion, as even CrystGAP was always loaded as "cryst".

- A second algorithm for the computation of Wyckoff positions
  (due to Ad Thiers) has been implemented. It avoids the computation
  of a subgroup lattice, and is faster in small dimensions.
  It is used by default for dimensions <= 4. The two available
  algorithms can be called directly using the functions

  WyPosAT( S );    # algorithm due to Ad Thiers
  WyPosSGL( S );   # algorithm using the subgroup lattice

  These functions are still undocumented.

- A bug in WyckoffGraph was fixed. The labels of the lines in the
  graph were not what was intended, and the manual was even
  selfcontradictory in this respect.

  This required code for intersections of affine subspace lattices,
  and a better subset test for affine subspace lattices.
  These are still undocumented.

- The function ConjugatorSpaceGroups is now documented.

- Cryst now tries to load the package polycyclic, and then installs
  methods for IsomorphismPcpGroup for PointGroups and AffineCrystGroups.

- A method for ImagesRepresentative for an IsomorphismFpGroup of an
  AffineCrystGroup has been added, so that the resulting isomorphism
  can now really be used.

- Switch to the new attribute MappingGeneratorsImages. Compatibility
  with GAP 4.2 and GAP 4.1 is maintained.

- A bug in Normalizer for two AffineCrystGroupsOnLeft was fixed;
  it returned an AffineCrystGroupOnRight.

- The number of generators returned by Normalizer for two
  AffineCrystGroups was reduced.

- A bug in ConjugacyClassesMaximalSubgroups for space groups was fixed;
  their size was set to a wrong value in certain cases.

- A mutability bug in AffineNormalizer was fixed.

## 4.0

Initial release for GAP 4.
