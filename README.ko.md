# MLOps 릴리스 관리 워크플로우

이 저장소는 GitHub Actions, release-please, 그리고 conventional commits를 사용한 완전한 MLOps 릴리스 관리 시스템을 보여줍니다.

## 🔄 브랜치 전략 (GitFlow)

```
Feature Branches → Dev Branch → Release Branch → Main Branch
```

### 브랜치 목적:
- **`main`**: 프로덕션 준비 완료 코드, 항상 안정적
- **`dev`**: 진행 중인 개발을 위한 통합 브랜치
- **`release-v*`**: 릴리스 준비 및 테스트 (예: `release-v2.2.0`)
- **`feature/*`**: 개별 기능 개발

## 📋 개발 워크플로우

### 1. 기능 개발
```bash
# dev에서 feature 브랜치 생성
git checkout dev
git pull origin dev
git checkout -b feature/user-authentication

# conventional commits로 기능 작업
git commit -m "feat: JWT 인증 시스템 추가"
git commit -m "fix: 토큰 만료 문제 해결"
git commit -m "docs: API 인증 가이드 업데이트"

# PR 생성: feature/user-authentication → dev
# 리뷰, 승인, PR 병합
```

### 2. 릴리스 준비
```bash
# 릴리스 준비가 되면 dev에서 release 브랜치 생성
git checkout dev
git pull origin dev
git checkout -b release-v2.2.0

# 철저한 테스트, 필요시 버그 수정
git commit -m "fix: 통합 테스트 실패 해결"

# PR 생성: release-v2.2.0 → main
# 리뷰, 승인, PR 병합
```

### 3. 자동화된 릴리스 프로세스
```
release-v2.2.0 → main 병합 후:

1. release-please가 main의 새로운 커밋 감지
2. 자동으로 Release PR 생성: "chore(main): release 2.2.0"
3. Release PR 포함 내용:
   - 업데이트된 CHANGELOG.md
   - 업데이트된 VERSION 파일
   - 업데이트된 pyproject.toml 버전
4. Release PR 리뷰 및 병합
5. GitHub Release v2.2.0 자동 생성
6. Docker 이미지 및 아티팩트 자동 빌드
```

## 🏷️ Conventional Commits

자동 체인지로그 생성을 위한 conventional commit 형식 사용:

### 커밋 타입:
- **`feat:`** - 새로운 기능 (minor 버전 증가)
- **`fix:`** - 버그 수정 (patch 버전 증가)
- **`docs:`** - 문서 변경
- **`perf:`** - 성능 개선
- **`build:`** - 빌드 시스템 변경
- **`ci:`** - CI/CD 변경
- **`style:`** - 코드 스타일 변경
- **`refactor:`** - 코드 리팩토링
- **`test:`** - 테스트 추가/변경
- **`chore:`** - 유지보수 작업

### 예시:
```bash
git commit -m "feat: ML 모델 버전 관리 시스템 추가"
git commit -m "fix: 데이터 전처리 메모리 누수 해결"
git commit -m "docs: Kubernetes 배포 가이드 업데이트"
git commit -m "perf: 추론 속도 40% 최적화"
git commit -m "feat!: API 구조 호환성 없는 변경"  # Major 버전 증가
```

## 🚀 릴리스 타입

### 시맨틱 버저닝 (SemVer):
- **Major (X.0.0)**: 호환성 없는 변경 (`feat!:`, `fix!:`, 또는 `BREAKING CHANGE`)
- **Minor (X.Y.0)**: 새로운 기능 (`feat:`)
- **Patch (X.Y.Z)**: 버그 수정 (`fix:`)

### 예시:
- `v1.0.0` → `v1.1.0` (새로운 기능)
- `v1.1.0` → `v1.1.1` (버그 수정)
- `v1.1.1` → `v2.0.0` (호환성 없는 변경)

## 🔧 자동화된 워크플로우

### 1. Release Please (`release-please.yml`)
- **트리거**: main 브랜치로 푸시
- **생성**: 체인지로그 및 버전 업데이트가 포함된 Release PR
- **분석**: 마지막 릴리스 이후 conventional commits

### 2. GitHub Release (`release.yml`)
- **트리거**: 태그 생성 (Release PR 병합 시)
- **생성**: 분류된 체인지로그가 포함된 GitHub Release
- **포함**: 커밋 해시 및 작성자 정보

### 3. Docker Release (`docker-release.yml`)
- **트리거**: 태그 생성
- **빌드**: 멀티플랫폼 Docker 이미지 (amd64/arm64)
- **게시**: GitHub Container Registry (GHCR)로
- **포함**: 보안 스캔 및 SBOM 생성

## 📦 생성되는 아티팩트

### 각 릴리스마다:
- **GitHub Release**: 상세한 체인지로그 포함
- **Docker 이미지**: 멀티플랫폼 컨테이너
- **SBOM**: 소프트웨어 구성 요소 명세서
- **보안 리포트**: 취약점 스캔 결과

### 생성되는 Docker 태그:
```
ghcr.io/username/repo:v2.2.0    # 정확한 버전
ghcr.io/username/repo:2.2.0     # SemVer
ghcr.io/username/repo:2.2       # Minor 버전
ghcr.io/username/repo:2         # Major 버전
ghcr.io/username/repo:latest    # 최신 릴리스
```

## 🔒 보안 기능

- **브랜치 검증**: main 브랜치에서만 릴리스
- **SemVer 검증**: 엄격한 버전 형식 강제
- **취약점 스캔**: Trivy 보안 분석
- **SBOM 생성**: 컴플라이언스 및 감사 지원
- **멀티플랫폼 빌드**: 향상된 호환성

## 🎯 완전한 워크플로우 예시

```
1. 개발자가 feature/ml-pipeline 브랜치 생성
2. 커밋: "feat: 분산 훈련 지원 추가"
3. PR 생성: feature/ml-pipeline → dev
4. 팀 리뷰 및 PR 병합

5. 릴리스 준비가 되면 dev에서 release-v2.2.0 생성
6. release 브랜치에서 테스트 및 이슈 수정
7. PR 생성: release-v2.2.0 → main
8. 팀 리뷰 및 PR 병합

9. release-please가 자동으로 Release PR 생성
10. Release PR 리뷰 (체인지로그 및 버전 증가 포함)
11. Release PR 병합

12. 자동 결과:
    - 향상된 체인지로그와 함께 GitHub Release v2.2.0 생성
    - 작성자 정보가 포함된 릴리스 노트 (by @username)
    - 이모지로 분류된 변경사항 (🚀 Features, 🐛 Bug Fixes, 등)
    - Docker 이미지 빌드 및 게시
    - 보안 스캔 완료
    - 다운로드 가능한 아티팩트
```

## 🛠️ 설정 요구사항

### 저장소 설정:
1. Settings → Actions → General로 이동
2. "Read and write permissions" 선택
3. "Allow GitHub Actions to create and approve pull requests" 체크

### 필수 파일:
- `.github/workflows/release-please.yml` - 작성자 향상 기능이 포함된 메인 자동화
- `version.txt` - 버전 추적
- `pyproject.toml` - 패키지 메타데이터

### 선택적 파일:
- `.release-please-config.json` - 사용자 정의 설정 (필수 아님, 기본값 사용)

## 📊 장점

- ✅ **자동화된 버전 관리** conventional commits 기반
- ✅ **전문적인 체인지로그** 분류된 변경사항 및 작성자 정보 포함
- ✅ **보안 스캔** 및 컴플라이언스 리포팅
- ✅ **멀티플랫폼 Docker 이미지** 광범위한 호환성
- ✅ **PR을 통한 리뷰 프로세스** 모든 릴리스에 대해
- ✅ **완전한 추적성** 커밋에서 릴리스까지
- ✅ **프로덕션 준비** MLOps 배포 파이프라인

## 🔗 유용한 링크

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [release-please 문서](https://github.com/googleapis/release-please)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

**이 워크플로우는 완전한 자동화, 보안, 컴플라이언스 기능을 갖춘 MLOps 프로젝트를 위한 엔터프라이즈급 릴리스 관리를 제공합니다.** 🚀
