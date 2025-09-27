#!/bin/bash
set -e  # exit if any command fails

# 🔑 Replace these with your details
ORG_KEY="org-testfordemo"
PROJECT_KEY="org-testfordemo_java-sample-app"
SONAR_HOST="https://sonarcloud.io"
SONAR_TOKEN="7625c3575ce2d8dfce7ebc7ec715df22392e3efd"

echo "🚀 Starting SonarQube analysis for Java project..."

# 1️⃣ Clean and run build + tests
echo "🔹 Running Maven verify (build + tests)..."
mvn clean verify

# 2️⃣ Run Sonar analysis
echo "🔹 Running SonarQube Scanner..."
mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
  -Dsonar.projectKey="$PROJECT_KEY" \
  -Dsonar.organization="$ORG_KEY" \
  -Dsonar.host.url="$SONAR_HOST" \
  -Dsonar.token="$SONAR_TOKEN" \
  -Dsonar.coverage.jacoco.xmlReportPaths="target/site/jacoco/jacoco.xml" \
  -Dsonar.exclusions="**/target/**,**/*.md,**/*.yml,**/Dockerfile"

echo "✅ Sonar analysis complete!"

# 3️⃣ Fetch SonarCloud Quality Gate summary
STATUS_JSON=$(curl -s -u "$SONAR_TOKEN:" \
  "$SONAR_HOST/api/qualitygates/project_status?projectKey=$PROJECT_KEY")

GATE_STATUS=$(echo "$STATUS_JSON" | jq -r '.projectStatus.status')
FAILED_CONDITIONS=$(echo "$STATUS_JSON" | jq -r '.projectStatus.conditions[] | select(.status=="ERROR") | "\(.metricKey): \(.actualValue) (expected: \(.errorThreshold))"')

JACOCO_FILE="target/site/jacoco/jacoco.xml"
if [ -f "$JACOCO_FILE" ]; then
  MISSED=$(xmllint --xpath 'string(sum(//counter[@type="LINE"]/@missed))' "$JACOCO_FILE")
  COVERED=$(xmllint --xpath 'string(sum(//counter[@type="LINE"]/@covered))' "$JACOCO_FILE")
  TOTAL=$((MISSED + COVERED))
  if [ "$TOTAL" -gt 0 ]; then
    PERCENT=$(( 100 * COVERED / TOTAL ))
    echo "🔍 Local Coverage: $PERCENT% ($COVERED/$TOTAL lines covered)"
  fi
else
  echo "⚠️ No JaCoCo XML report found"
fi


echo "================== SonarCloud Quality Gate =================="
echo "Project: $PROJECT_KEY"
echo "Status: $GATE_STATUS"
if [[ -n "$FAILED_CONDITIONS" ]]; then
  echo "❌ Failed conditions:"
  echo "$FAILED_CONDITIONS"
else
  echo "✅ All conditions passed!"
fi
echo "=============================================================="