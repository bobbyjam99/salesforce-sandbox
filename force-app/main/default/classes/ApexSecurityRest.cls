/**
 * 認定 Platform デベロッパー資格の更新 (Winter '21)
 * https://trailhead.salesforce.com/ja/content/learn/modules/platform-developer-i-certification-maintenance-winter-21/get-handson-with-field-and-objectlevel-security-and-safe-navigation-operator
 * 
 * + 取引先責任者オブジェクトに、機密データや守秘データを保持する新しいカスタム項目を作成します。
 *   + 項目の表示ラベル: Top Secret (極秘)
 *   + データ型: テキスト
 *   + 項目名: Top_Secret
 *   + 文字数: 255
 * + 項目レベルセキュリティを定義するときに、[標準ユーザ] プロファイルの [参照可能] ボックスをオフにします。
 */
@RestResource(urlMapping='/apexSecurityRest')
global with sharing class ApexSecurityRest {

    @HttpGet
    global static Contact doGet() {

        Id recordId = RestContext.request.params.get('id');
        if (recordId == null) {
            throw new FunctionalException('Id parameter is required');
        }

        Contact result;
        SObjectAccessDecision securityDecision = Security.stripInaccessible(
            AccessType.READABLE,
            [SELECT Id, Name, TItle, Top_Secret__c, Account.Name FROM Contact WHERE Id = :recordId]
        );

        List<SObject> secResults = Security.stripInaccessible(
                AccessType.UPDATABLE,
                securityDecision.getRecords()
            ).getRecords();
        if (!secResults.isEmpty()) {
            result = (Contact) secResults[0];
            result.Description = result.Account?.Name;
        }
        return result;
    }
    public class FunctionalException extends Exception{}
}
