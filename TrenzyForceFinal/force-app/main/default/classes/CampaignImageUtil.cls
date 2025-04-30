public class CampaignImageUtil {
    public static String generateCampaignImagePublicUrl(Id campaignId) {
        // Step 1: Get the ContentDocumentId
        ContentDocumentLink cdl = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :campaignId
            LIMIT 1
        ];

        if (cdl == null) return null;

        Id contentDocId = cdl.ContentDocumentId;

        // Step 2: Get the latest ContentVersion (optional)
        ContentVersion version = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId = :contentDocId
            ORDER BY VersionNumber DESC
            LIMIT 1
        ];

        // Step 3: Check if there's already a distribution
        List<ContentDistribution> existing = [
            SELECT DistributionPublicUrl
            FROM ContentDistribution
            WHERE ContentVersionId = :version.Id
            LIMIT 1
        ];

        if (!existing.isEmpty()) {
            system.debug('URL:'+existing[0].DistributionPublicUrl);
            return existing[0].DistributionPublicUrl;
        }

        // Step 4: Create new ContentDistribution
        ContentDistribution cd = new ContentDistribution(
            Name = 'PublicLink',
            ContentVersionId = version.Id,
            PreferencesAllowViewInBrowser = true,
            PreferencesLinkLatestVersion = true,
            PreferencesNotifyOnVisit = false
        );
        insert cd;
		system.debug('URL:'+cd.DistributionPublicUrl);
        return cd.DistributionPublicUrl;
    }
}