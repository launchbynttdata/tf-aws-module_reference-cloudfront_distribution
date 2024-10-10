package testimpl

import (

	"context"
	"github.com/aws/aws-sdk-go-v2/service/acm"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {

	// When cloning the skeleton to a new module, you will need to change the below test
	// to meet your needs and add any new tests that apply to your situation.
	// Other tests would go here and can use functions from lcaf-component-terratest.
	// Examples (from lambda):
	// functionName := terraform.Output(t, ctx.TerratestTerraformOptions, "function_name")
	// require.NotEmpty(t, functionName, "name of deployed lambda should be set")
	// awsApiLambdaClient := test_helper_lambda.GetAWSApiLambdaClient(t)
	// test_helper_lambda.WaitForLambdaSpinUp(t, awsApiLambdaClient, functionName)
	// test_helper_lambda.TestIsLambdaInvokable(t, awsApiLambdaClient, functionName)
	// test_helper_lambda.TestLambdaTags(t, awsApiLambdaClient, functionName, ctx.TestConfig.(*ThisTFModuleConfig).Tags)

	cloudfrontClient := cloudfront.NewFromConfig(GetAWSConfig(t))

	t.Run("TestCloudfrontID", func(t *testing.T) {
		cloudFrontDistributionID := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_id")
		assert.NotEmpty(t, cloudFrontDistributionID, "CloudFront Distribution ID should not be empty")

		awsCloudfrontDistribution, err := cloudfrontClient.GetDistribution(context.TODO(), &cloudfront.GetDistributionInput{
			Id: &cloudFrontDistributionID,
		})
		if err != nil {
			t.Errorf("Failure during GetDistribution: %v", err)
		}
		assert.Equal(t, *awsCloudfrontDistribution.Distribution.Id, cloudFrontDistributionID, "Expected ID did not match actual ID!")
	})

	t.Run("TestCloudfrontARN", func(t *testing.T) {
		cloudFrontDistributionARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_arn")
		cloudFrontDistributionID := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_id")
		assert.NotEmpty(t, cloudFrontDistributionARN, "CloudFront Distribution ARN should not be empty")

		awsCloudfrontDistribution, err := cloudfrontClient.GetDistribution(context.TODO(), &cloudfront.GetDistributionInput{
			Id: &cloudFrontDistributionID,
		})
		if err != nil {
			t.Errorf("Failure during GetDistribution: %v", err)
		}
		assert.Equal(t, *awsCloudfrontDistribution.Distribution.ARN, cloudFrontDistributionARN, "Expected ARN did not match actual ARN!")
	})

	t.Run("TestCloudfrontStatus", func(t *testing.T) {
		cloudFrontDistributionStatus := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_status")
		cloudFrontDistributionID := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_id")
		assert.NotEmpty(t, cloudFrontDistributionStatus, "CloudFront Distribution Status should not be empty")

		awsCloudfrontDistribution, err := cloudfrontClient.GetDistribution(context.TODO(), &cloudfront.GetDistributionInput{
			Id: &cloudFrontDistributionID,
		})
		if err != nil {
			t.Errorf("Failure during GetDistribution: %v", err)
		}
		assert.Equal(t, *awsCloudfrontDistribution.Distribution.Status, cloudFrontDistributionStatus, "Expected Status did not match actual Status!")
	})

	t.Run("TestCloudfrontDomainName", func(t *testing.T) {
		cloudFrontDistributionDomainName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_domain_name")
		cloudFrontDistributionID := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_id")
		assert.NotEmpty(t, cloudFrontDistributionDomainName, "CloudFront Distribution Domain Name should not be empty")

		awsCloudfrontDistribution, err := cloudfrontClient.GetDistribution(context.TODO(), &cloudfront.GetDistributionInput{
			Id: &cloudFrontDistributionID,
		})
		if err != nil {
			t.Errorf("Failure during GetDistribution: %v", err)
		}
		assert.Equal(t, *awsCloudfrontDistribution.Distribution.DomainName, cloudFrontDistributionDomainName, "Expected Status did not match actual Status!")
	})

	acmClient := acm.NewFromConfig(GetAWSConfig(t))

	t.Run("TestACMCertificateARN", func(t *testing.T) {
		certificateARN := terraform.Output(t, ctx.TerratestTerraformOptions(), "acm_certificate_arn")
		assert.NotEmpty(t, certificateARN, "ACM Certificate ARN should not be empty")

		awsACMCertificate, err := acmClient.DescribeCertificate(context.TODO(), &acm.DescribeCertificateInput{
			CertificateArn: &certificateARN,
		})
		if err != nil {
			t.Errorf("Failure during GetCertificate: %v", err)
		}

		assert.Equal(t, *awsACMCertificate.Certificate.CertificateArn, certificateARN, "Expected ARN did not match actual ARN!")
	})

}

// GetAWSConfig loads the AWS configuration
func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
