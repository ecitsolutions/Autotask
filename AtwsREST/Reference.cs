namespace Autotask {

    public class Query {

        private object maxRecordsField;
        private object includeFieldsField;
        private object filterField;
  

        public object maxRecords {
            get {
                return this.maxRecordsField;
            }
            set {
                this.maxRecordsField = value;
            }
        }
        public object includeFields {
            get {
                return this.includeFieldsField;
            }
            set {
                this.includeFieldsField = value;
            }
        }
        public object filter {
            get {
                return this.filterField;
            }
            set {
                this.filterField = value;
            }
        }

    }

    public class ActionType {

        private object idField;
        private object nameField;
        private object isActiveField;
        private object isSystemActionTypeField;
        private object viewField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isSystemActionType {
            get {
                return this.isSystemActionTypeField;
            }
            set {
                this.isSystemActionTypeField = value;
            }
        }
        public object view {
            get {
                return this.viewField;
            }
            set {
                this.viewField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class UserDefinedField {

        private object nameField;
        private object valueField;
  

        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object value {
            get {
                return this.valueField;
            }
            set {
                this.valueField = value;
            }
        }

    }

    public class Appointment {

        private object idField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object endDateTimeField;
        private object resourceIDField;
        private object startDateTimeField;
        private object titleField;
        private object updateDateTimeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object updateDateTime {
            get {
                return this.updateDateTimeField;
            }
            set {
                this.updateDateTimeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleAttachment {

        private object idField;
        private object articleIDField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ParameterExpression {

        private object typeField;
        private object nodeTypeField;
        private object nameField;
        private object isByRefField;
        private object canReduceField;
  

        public object type {
            get {
                return this.typeField;
            }
            set {
                this.typeField = value;
            }
        }
        public object nodeType {
            get {
                return this.nodeTypeField;
            }
            set {
                this.nodeTypeField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object isByRef {
            get {
                return this.isByRefField;
            }
            set {
                this.isByRefField = value;
            }
        }
        public object canReduce {
            get {
                return this.canReduceField;
            }
            set {
                this.canReduceField = value;
            }
        }

    }

    public class Expression {

        private object nodeTypeField;
        private object typeField;
        private object canReduceField;
  

        public object nodeType {
            get {
                return this.nodeTypeField;
            }
            set {
                this.nodeTypeField = value;
            }
        }
        public object type {
            get {
                return this.typeField;
            }
            set {
                this.typeField = value;
            }
        }
        public object canReduce {
            get {
                return this.canReduceField;
            }
            set {
                this.canReduceField = value;
            }
        }

    }

    public class ArticleConfigurationItemCategoryAssociation {

        private object idField;
        private object articleIDField;
        private object installedProductCategoryIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object installedProductCategoryID {
            get {
                return this.installedProductCategoryIDField;
            }
            set {
                this.installedProductCategoryIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleNote {

        private object idField;
        private object createdByResourceIDField;
        private object createdDateTimeField;
        private object descriptionField;
        private object articleIDField;
        private object lastModifiedByResourceIDField;
        private object lastModifiedDateTimeField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object createdDateTime {
            get {
                return this.createdDateTimeField;
            }
            set {
                this.createdDateTimeField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object lastModifiedByResourceID {
            get {
                return this.lastModifiedByResourceIDField;
            }
            set {
                this.lastModifiedByResourceIDField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticlePlainTextContent {

        private object idField;
        private object contentDataField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contentData {
            get {
                return this.contentDataField;
            }
            set {
                this.contentDataField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleTagAssociation {

        private object idField;
        private object createDateTimeField;
        private object createdByResourceIDField;
        private object articleIDField;
        private object tagIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object tagID {
            get {
                return this.tagIDField;
            }
            set {
                this.tagIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleTicketAssociation {

        private object idField;
        private object articleIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleToArticleAssociation {

        private object idField;
        private object associatedArticleIDField;
        private object articleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object associatedArticleID {
            get {
                return this.associatedArticleIDField;
            }
            set {
                this.associatedArticleIDField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ArticleToDocumentAssociation {

        private object idField;
        private object associatedDocumentIDField;
        private object articleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object associatedDocumentID {
            get {
                return this.associatedDocumentIDField;
            }
            set {
                this.associatedDocumentIDField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class BillingItemApprovalLevel {

        private object idField;
        private object approvalDateTimeField;
        private object approvalLevelField;
        private object approvalResourceIDField;
        private object timeEntryIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object approvalDateTime {
            get {
                return this.approvalDateTimeField;
            }
            set {
                this.approvalDateTimeField = value;
            }
        }
        public object approvalLevel {
            get {
                return this.approvalLevelField;
            }
            set {
                this.approvalLevelField = value;
            }
        }
        public object approvalResourceID {
            get {
                return this.approvalResourceIDField;
            }
            set {
                this.approvalResourceIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class BillingItem {

        private object idField;
        private object accountManagerWhenApprovedIDField;
        private object billingCodeIDField;
        private object billingItemTypeField;
        private object companyIDField;
        private object configurationItemIDField;
        private object contractChargeIDField;
        private object contractIDField;
        private object contractServiceAdjustmentIDField;
        private object contractServiceBundleAdjustmentIDField;
        private object contractServiceBundleIDField;
        private object contractServiceBundlePeriodIDField;
        private object contractServiceIDField;
        private object contractServicePeriodIDField;
        private object descriptionField;
        private object expenseItemIDField;
        private object extendedPriceField;
        private object internalCurrencyExtendedPriceField;
        private object internalCurrencyRateField;
        private object internalCurrencyTaxDollarsField;
        private object internalCurrencyTotalAmountField;
        private object invoiceIDField;
        private object itemApproverIDField;
        private object itemDateField;
        private object itemNameField;
        private object lineItemFullDescriptionField;
        private object lineItemGroupDescriptionField;
        private object milestoneIDField;
        private object nonBillableField;
        private object organizationalLevelAssociationIDField;
        private object ourCostField;
        private object postedDateField;
        private object postedOnTimeField;
        private object projectChargeIDField;
        private object projectIDField;
        private object purchaseOrderNumberField;
        private object quantityField;
        private object rateField;
        private object roleIDField;
        private object serviceBundleIDField;
        private object serviceIDField;
        private object sortOrderIDField;
        private object subTypeField;
        private object taskIDField;
        private object taxDollarsField;
        private object ticketChargeIDField;
        private object ticketIDField;
        private object timeEntryIDField;
        private object totalAmountField;
        private object vendorIDField;
        private object webServiceDateField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object accountManagerWhenApprovedID {
            get {
                return this.accountManagerWhenApprovedIDField;
            }
            set {
                this.accountManagerWhenApprovedIDField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object billingItemType {
            get {
                return this.billingItemTypeField;
            }
            set {
                this.billingItemTypeField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object contractChargeID {
            get {
                return this.contractChargeIDField;
            }
            set {
                this.contractChargeIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceAdjustmentID {
            get {
                return this.contractServiceAdjustmentIDField;
            }
            set {
                this.contractServiceAdjustmentIDField = value;
            }
        }
        public object contractServiceBundleAdjustmentID {
            get {
                return this.contractServiceBundleAdjustmentIDField;
            }
            set {
                this.contractServiceBundleAdjustmentIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceBundlePeriodID {
            get {
                return this.contractServiceBundlePeriodIDField;
            }
            set {
                this.contractServiceBundlePeriodIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object contractServicePeriodID {
            get {
                return this.contractServicePeriodIDField;
            }
            set {
                this.contractServicePeriodIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object expenseItemID {
            get {
                return this.expenseItemIDField;
            }
            set {
                this.expenseItemIDField = value;
            }
        }
        public object extendedPrice {
            get {
                return this.extendedPriceField;
            }
            set {
                this.extendedPriceField = value;
            }
        }
        public object internalCurrencyExtendedPrice {
            get {
                return this.internalCurrencyExtendedPriceField;
            }
            set {
                this.internalCurrencyExtendedPriceField = value;
            }
        }
        public object internalCurrencyRate {
            get {
                return this.internalCurrencyRateField;
            }
            set {
                this.internalCurrencyRateField = value;
            }
        }
        public object internalCurrencyTaxDollars {
            get {
                return this.internalCurrencyTaxDollarsField;
            }
            set {
                this.internalCurrencyTaxDollarsField = value;
            }
        }
        public object internalCurrencyTotalAmount {
            get {
                return this.internalCurrencyTotalAmountField;
            }
            set {
                this.internalCurrencyTotalAmountField = value;
            }
        }
        public object invoiceID {
            get {
                return this.invoiceIDField;
            }
            set {
                this.invoiceIDField = value;
            }
        }
        public object itemApproverID {
            get {
                return this.itemApproverIDField;
            }
            set {
                this.itemApproverIDField = value;
            }
        }
        public object itemDate {
            get {
                return this.itemDateField;
            }
            set {
                this.itemDateField = value;
            }
        }
        public object itemName {
            get {
                return this.itemNameField;
            }
            set {
                this.itemNameField = value;
            }
        }
        public object lineItemFullDescription {
            get {
                return this.lineItemFullDescriptionField;
            }
            set {
                this.lineItemFullDescriptionField = value;
            }
        }
        public object lineItemGroupDescription {
            get {
                return this.lineItemGroupDescriptionField;
            }
            set {
                this.lineItemGroupDescriptionField = value;
            }
        }
        public object milestoneID {
            get {
                return this.milestoneIDField;
            }
            set {
                this.milestoneIDField = value;
            }
        }
        public object nonBillable {
            get {
                return this.nonBillableField;
            }
            set {
                this.nonBillableField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object ourCost {
            get {
                return this.ourCostField;
            }
            set {
                this.ourCostField = value;
            }
        }
        public object postedDate {
            get {
                return this.postedDateField;
            }
            set {
                this.postedDateField = value;
            }
        }
        public object postedOnTime {
            get {
                return this.postedOnTimeField;
            }
            set {
                this.postedOnTimeField = value;
            }
        }
        public object projectChargeID {
            get {
                return this.projectChargeIDField;
            }
            set {
                this.projectChargeIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object quantity {
            get {
                return this.quantityField;
            }
            set {
                this.quantityField = value;
            }
        }
        public object rate {
            get {
                return this.rateField;
            }
            set {
                this.rateField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object sortOrderID {
            get {
                return this.sortOrderIDField;
            }
            set {
                this.sortOrderIDField = value;
            }
        }
        public object subType {
            get {
                return this.subTypeField;
            }
            set {
                this.subTypeField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object taxDollars {
            get {
                return this.taxDollarsField;
            }
            set {
                this.taxDollarsField = value;
            }
        }
        public object ticketChargeID {
            get {
                return this.ticketChargeIDField;
            }
            set {
                this.ticketChargeIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object totalAmount {
            get {
                return this.totalAmountField;
            }
            set {
                this.totalAmountField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object webServiceDate {
            get {
                return this.webServiceDateField;
            }
            set {
                this.webServiceDateField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ChangeOrderCharge {

        private object idField;
        private object billableAmountField;
        private object billingCodeIDField;
        private object changeOrderHoursField;
        private object chargeTypeField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object datePurchasedField;
        private object descriptionField;
        private object extendedCostField;
        private object internalCurrencyBillableAmountField;
        private object internalCurrencyUnitPriceField;
        private object internalPurchaseOrderNumberField;
        private object isBillableToCompanyField;
        private object isBilledField;
        private object nameField;
        private object notesField;
        private object organizationalLevelAssociationIDField;
        private object productIDField;
        private object purchaseOrderNumberField;
        private object statusField;
        private object statusLastModifiedByField;
        private object statusLastModifiedDateField;
        private object taskIDField;
        private object unitCostField;
        private object unitPriceField;
        private object unitQuantityField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billableAmount {
            get {
                return this.billableAmountField;
            }
            set {
                this.billableAmountField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object changeOrderHours {
            get {
                return this.changeOrderHoursField;
            }
            set {
                this.changeOrderHoursField = value;
            }
        }
        public object chargeType {
            get {
                return this.chargeTypeField;
            }
            set {
                this.chargeTypeField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object extendedCost {
            get {
                return this.extendedCostField;
            }
            set {
                this.extendedCostField = value;
            }
        }
        public object internalCurrencyBillableAmount {
            get {
                return this.internalCurrencyBillableAmountField;
            }
            set {
                this.internalCurrencyBillableAmountField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalPurchaseOrderNumber {
            get {
                return this.internalPurchaseOrderNumberField;
            }
            set {
                this.internalPurchaseOrderNumberField = value;
            }
        }
        public object isBillableToCompany {
            get {
                return this.isBillableToCompanyField;
            }
            set {
                this.isBillableToCompanyField = value;
            }
        }
        public object isBilled {
            get {
                return this.isBilledField;
            }
            set {
                this.isBilledField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object statusLastModifiedBy {
            get {
                return this.statusLastModifiedByField;
            }
            set {
                this.statusLastModifiedByField = value;
            }
        }
        public object statusLastModifiedDate {
            get {
                return this.statusLastModifiedDateField;
            }
            set {
                this.statusLastModifiedDateField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object unitQuantity {
            get {
                return this.unitQuantityField;
            }
            set {
                this.unitQuantityField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ChangeRequestLink {

        private object idField;
        private object changeRequestTicketIDField;
        private object problemOrIncidentTicketIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object changeRequestTicketID {
            get {
                return this.changeRequestTicketIDField;
            }
            set {
                this.changeRequestTicketIDField = value;
            }
        }
        public object problemOrIncidentTicketID {
            get {
                return this.problemOrIncidentTicketIDField;
            }
            set {
                this.problemOrIncidentTicketIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ChecklistLibrary {

        private object idField;
        private object descriptionField;
        private object entityTypeField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object entityType {
            get {
                return this.entityTypeField;
            }
            set {
                this.entityTypeField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ChecklistLibraryChecklistItem {

        private object idField;
        private object checklistLibraryIDField;
        private object isImportantField;
        private object itemNameField;
        private object knowledgebaseArticleIDField;
        private object positionField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object checklistLibraryID {
            get {
                return this.checklistLibraryIDField;
            }
            set {
                this.checklistLibraryIDField = value;
            }
        }
        public object isImportant {
            get {
                return this.isImportantField;
            }
            set {
                this.isImportantField = value;
            }
        }
        public object itemName {
            get {
                return this.itemNameField;
            }
            set {
                this.itemNameField = value;
            }
        }
        public object knowledgebaseArticleID {
            get {
                return this.knowledgebaseArticleIDField;
            }
            set {
                this.knowledgebaseArticleIDField = value;
            }
        }
        public object position {
            get {
                return this.positionField;
            }
            set {
                this.positionField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ClientPortalUser {

        private object idField;
        private object contactIDField;
        private object dateFormatField;
        private object isClientPortalActiveField;
        private object numberFormatField;
        private object passwordField;
        private object securityLevelField;
        private object timeFormatField;
        private object userNameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object dateFormat {
            get {
                return this.dateFormatField;
            }
            set {
                this.dateFormatField = value;
            }
        }
        public object isClientPortalActive {
            get {
                return this.isClientPortalActiveField;
            }
            set {
                this.isClientPortalActiveField = value;
            }
        }
        public object numberFormat {
            get {
                return this.numberFormatField;
            }
            set {
                this.numberFormatField = value;
            }
        }
        public object password {
            get {
                return this.passwordField;
            }
            set {
                this.passwordField = value;
            }
        }
        public object securityLevel {
            get {
                return this.securityLevelField;
            }
            set {
                this.securityLevelField = value;
            }
        }
        public object timeFormat {
            get {
                return this.timeFormatField;
            }
            set {
                this.timeFormatField = value;
            }
        }
        public object userName {
            get {
                return this.userNameField;
            }
            set {
                this.userNameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ComanagedAssociation {

        private object idField;
        private object companyIDField;
        private object resourceIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Company {

        private object idField;
        private object additionalAddressInformationField;
        private object address1Field;
        private object address2Field;
        private object alternatePhone1Field;
        private object alternatePhone2Field;
        private object apiVendorIDField;
        private object assetValueField;
        private object billToCompanyLocationIDField;
        private object billToAdditionalAddressInformationField;
        private object billingAddress1Field;
        private object billingAddress2Field;
        private object billToAddressToUseField;
        private object billToAttentionField;
        private object billToCityField;
        private object billToCountryIDField;
        private object billToStateField;
        private object billToZipCodeField;
        private object cityField;
        private object classificationField;
        private object companyCategoryIDField;
        private object companyNameField;
        private object companyNumberField;
        private object companyTypeField;
        private object competitorIDField;
        private object countryIDField;
        private object createDateField;
        private object createdByResourceIDField;
        private object currencyIDField;
        private object faxField;
        private object impersonatorCreatorResourceIDField;
        private object invoiceEmailMessageIDField;
        private object invoiceMethodField;
        private object invoiceNonContractItemsToParentCompanyField;
        private object invoiceTemplateIDField;
        private object isActiveField;
        private object isClientPortalActiveField;
        private object isEnabledForComanagedField;
        private object isTaskFireActiveField;
        private object isTaxExemptField;
        private object lastActivityDateField;
        private object lastTrackedModifiedDateTimeField;
        private object marketSegmentIDField;
        private object ownerResourceIDField;
        private object parentCompanyIDField;
        private object phoneField;
        private object postalCodeField;
        private object purchaseOrderTemplateIDField;
        private object quoteEmailMessageIDField;
        private object quoteTemplateIDField;
        private object sicCodeField;
        private object stateField;
        private object stockMarketField;
        private object stockSymbolField;
        private object surveyCompanyRatingField;
        private object taxIDField;
        private object taxRegionIDField;
        private object territoryIDField;
        private object webAddressField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalAddressInformation {
            get {
                return this.additionalAddressInformationField;
            }
            set {
                this.additionalAddressInformationField = value;
            }
        }
        public object address1 {
            get {
                return this.address1Field;
            }
            set {
                this.address1Field = value;
            }
        }
        public object address2 {
            get {
                return this.address2Field;
            }
            set {
                this.address2Field = value;
            }
        }
        public object alternatePhone1 {
            get {
                return this.alternatePhone1Field;
            }
            set {
                this.alternatePhone1Field = value;
            }
        }
        public object alternatePhone2 {
            get {
                return this.alternatePhone2Field;
            }
            set {
                this.alternatePhone2Field = value;
            }
        }
        public object apiVendorID {
            get {
                return this.apiVendorIDField;
            }
            set {
                this.apiVendorIDField = value;
            }
        }
        public object assetValue {
            get {
                return this.assetValueField;
            }
            set {
                this.assetValueField = value;
            }
        }
        public object billToCompanyLocationID {
            get {
                return this.billToCompanyLocationIDField;
            }
            set {
                this.billToCompanyLocationIDField = value;
            }
        }
        public object billToAdditionalAddressInformation {
            get {
                return this.billToAdditionalAddressInformationField;
            }
            set {
                this.billToAdditionalAddressInformationField = value;
            }
        }
        public object billingAddress1 {
            get {
                return this.billingAddress1Field;
            }
            set {
                this.billingAddress1Field = value;
            }
        }
        public object billingAddress2 {
            get {
                return this.billingAddress2Field;
            }
            set {
                this.billingAddress2Field = value;
            }
        }
        public object billToAddressToUse {
            get {
                return this.billToAddressToUseField;
            }
            set {
                this.billToAddressToUseField = value;
            }
        }
        public object billToAttention {
            get {
                return this.billToAttentionField;
            }
            set {
                this.billToAttentionField = value;
            }
        }
        public object billToCity {
            get {
                return this.billToCityField;
            }
            set {
                this.billToCityField = value;
            }
        }
        public object billToCountryID {
            get {
                return this.billToCountryIDField;
            }
            set {
                this.billToCountryIDField = value;
            }
        }
        public object billToState {
            get {
                return this.billToStateField;
            }
            set {
                this.billToStateField = value;
            }
        }
        public object billToZipCode {
            get {
                return this.billToZipCodeField;
            }
            set {
                this.billToZipCodeField = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object classification {
            get {
                return this.classificationField;
            }
            set {
                this.classificationField = value;
            }
        }
        public object companyCategoryID {
            get {
                return this.companyCategoryIDField;
            }
            set {
                this.companyCategoryIDField = value;
            }
        }
        public object companyName {
            get {
                return this.companyNameField;
            }
            set {
                this.companyNameField = value;
            }
        }
        public object companyNumber {
            get {
                return this.companyNumberField;
            }
            set {
                this.companyNumberField = value;
            }
        }
        public object companyType {
            get {
                return this.companyTypeField;
            }
            set {
                this.companyTypeField = value;
            }
        }
        public object competitorID {
            get {
                return this.competitorIDField;
            }
            set {
                this.competitorIDField = value;
            }
        }
        public object countryID {
            get {
                return this.countryIDField;
            }
            set {
                this.countryIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object fax {
            get {
                return this.faxField;
            }
            set {
                this.faxField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object invoiceEmailMessageID {
            get {
                return this.invoiceEmailMessageIDField;
            }
            set {
                this.invoiceEmailMessageIDField = value;
            }
        }
        public object invoiceMethod {
            get {
                return this.invoiceMethodField;
            }
            set {
                this.invoiceMethodField = value;
            }
        }
        public object invoiceNonContractItemsToParentCompany {
            get {
                return this.invoiceNonContractItemsToParentCompanyField;
            }
            set {
                this.invoiceNonContractItemsToParentCompanyField = value;
            }
        }
        public object invoiceTemplateID {
            get {
                return this.invoiceTemplateIDField;
            }
            set {
                this.invoiceTemplateIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isClientPortalActive {
            get {
                return this.isClientPortalActiveField;
            }
            set {
                this.isClientPortalActiveField = value;
            }
        }
        public object isEnabledForComanaged {
            get {
                return this.isEnabledForComanagedField;
            }
            set {
                this.isEnabledForComanagedField = value;
            }
        }
        public object isTaskFireActive {
            get {
                return this.isTaskFireActiveField;
            }
            set {
                this.isTaskFireActiveField = value;
            }
        }
        public object isTaxExempt {
            get {
                return this.isTaxExemptField;
            }
            set {
                this.isTaxExemptField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object lastTrackedModifiedDateTime {
            get {
                return this.lastTrackedModifiedDateTimeField;
            }
            set {
                this.lastTrackedModifiedDateTimeField = value;
            }
        }
        public object marketSegmentID {
            get {
                return this.marketSegmentIDField;
            }
            set {
                this.marketSegmentIDField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object parentCompanyID {
            get {
                return this.parentCompanyIDField;
            }
            set {
                this.parentCompanyIDField = value;
            }
        }
        public object phone {
            get {
                return this.phoneField;
            }
            set {
                this.phoneField = value;
            }
        }
        public object postalCode {
            get {
                return this.postalCodeField;
            }
            set {
                this.postalCodeField = value;
            }
        }
        public object purchaseOrderTemplateID {
            get {
                return this.purchaseOrderTemplateIDField;
            }
            set {
                this.purchaseOrderTemplateIDField = value;
            }
        }
        public object quoteEmailMessageID {
            get {
                return this.quoteEmailMessageIDField;
            }
            set {
                this.quoteEmailMessageIDField = value;
            }
        }
        public object quoteTemplateID {
            get {
                return this.quoteTemplateIDField;
            }
            set {
                this.quoteTemplateIDField = value;
            }
        }
        public object sicCode {
            get {
                return this.sicCodeField;
            }
            set {
                this.sicCodeField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object stockMarket {
            get {
                return this.stockMarketField;
            }
            set {
                this.stockMarketField = value;
            }
        }
        public object stockSymbol {
            get {
                return this.stockSymbolField;
            }
            set {
                this.stockSymbolField = value;
            }
        }
        public object surveyCompanyRating {
            get {
                return this.surveyCompanyRatingField;
            }
            set {
                this.surveyCompanyRatingField = value;
            }
        }
        public object taxID {
            get {
                return this.taxIDField;
            }
            set {
                this.taxIDField = value;
            }
        }
        public object taxRegionID {
            get {
                return this.taxRegionIDField;
            }
            set {
                this.taxRegionIDField = value;
            }
        }
        public object territoryID {
            get {
                return this.territoryIDField;
            }
            set {
                this.territoryIDField = value;
            }
        }
        public object webAddress {
            get {
                return this.webAddressField;
            }
            set {
                this.webAddressField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyAlert {

        private object idField;
        private object alertTextField;
        private object alertTypeIDField;
        private object companyIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object alertText {
            get {
                return this.alertTextField;
            }
            set {
                this.alertTextField = value;
            }
        }
        public object alertTypeID {
            get {
                return this.alertTypeIDField;
            }
            set {
                this.alertTypeIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object companyIDField;
        private object companyNoteIDField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object publishField;
        private object salesOrderIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyNoteID {
            get {
                return this.companyNoteIDField;
            }
            set {
                this.companyNoteIDField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class CompanyCategory {

        private object idField;
        private object displayColorRGBField;
        private object isActiveField;
        private object isApiOnlyField;
        private object isGlobalDefaultField;
        private object nameField;
        private object nicknameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object displayColorRGB {
            get {
                return this.displayColorRGBField;
            }
            set {
                this.displayColorRGBField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isApiOnly {
            get {
                return this.isApiOnlyField;
            }
            set {
                this.isApiOnlyField = value;
            }
        }
        public object isGlobalDefault {
            get {
                return this.isGlobalDefaultField;
            }
            set {
                this.isGlobalDefaultField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object nickname {
            get {
                return this.nicknameField;
            }
            set {
                this.nicknameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Contact {

        private object idField;
        private object additionalAddressInformationField;
        private object addressLineField;
        private object addressLine1Field;
        private object alternatePhoneField;
        private object apiVendorIDField;
        private object bulkEmailOptOutTimeField;
        private object cityField;
        private object companyIDField;
        private object companyLocationIDField;
        private object countryIDField;
        private object createDateField;
        private object emailAddressField;
        private object emailAddress2Field;
        private object emailAddress3Field;
        private object extensionField;
        private object externalIDField;
        private object facebookUrlField;
        private object faxNumberField;
        private object firstNameField;
        private object impersonatorCreatorResourceIDField;
        private object isActiveField;
        private object isOptedOutFromBulkEmailField;
        private object lastActivityDateField;
        private object lastModifiedDateField;
        private object lastNameField;
        private object linkedInUrlField;
        private object middleInitialField;
        private object mobilePhoneField;
        private object namePrefixField;
        private object nameSuffixField;
        private object noteField;
        private object receivesEmailNotificationsField;
        private object phoneField;
        private object primaryContactField;
        private object roomNumberField;
        private object solicitationOptOutField;
        private object solicitationOptOutTimeField;
        private object stateField;
        private object surveyOptOutField;
        private object titleField;
        private object twitterUrlField;
        private object zipCodeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalAddressInformation {
            get {
                return this.additionalAddressInformationField;
            }
            set {
                this.additionalAddressInformationField = value;
            }
        }
        public object addressLine {
            get {
                return this.addressLineField;
            }
            set {
                this.addressLineField = value;
            }
        }
        public object addressLine1 {
            get {
                return this.addressLine1Field;
            }
            set {
                this.addressLine1Field = value;
            }
        }
        public object alternatePhone {
            get {
                return this.alternatePhoneField;
            }
            set {
                this.alternatePhoneField = value;
            }
        }
        public object apiVendorID {
            get {
                return this.apiVendorIDField;
            }
            set {
                this.apiVendorIDField = value;
            }
        }
        public object bulkEmailOptOutTime {
            get {
                return this.bulkEmailOptOutTimeField;
            }
            set {
                this.bulkEmailOptOutTimeField = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object countryID {
            get {
                return this.countryIDField;
            }
            set {
                this.countryIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object emailAddress {
            get {
                return this.emailAddressField;
            }
            set {
                this.emailAddressField = value;
            }
        }
        public object emailAddress2 {
            get {
                return this.emailAddress2Field;
            }
            set {
                this.emailAddress2Field = value;
            }
        }
        public object emailAddress3 {
            get {
                return this.emailAddress3Field;
            }
            set {
                this.emailAddress3Field = value;
            }
        }
        public object extension {
            get {
                return this.extensionField;
            }
            set {
                this.extensionField = value;
            }
        }
        public object externalID {
            get {
                return this.externalIDField;
            }
            set {
                this.externalIDField = value;
            }
        }
        public object facebookUrl {
            get {
                return this.facebookUrlField;
            }
            set {
                this.facebookUrlField = value;
            }
        }
        public object faxNumber {
            get {
                return this.faxNumberField;
            }
            set {
                this.faxNumberField = value;
            }
        }
        public object firstName {
            get {
                return this.firstNameField;
            }
            set {
                this.firstNameField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isOptedOutFromBulkEmail {
            get {
                return this.isOptedOutFromBulkEmailField;
            }
            set {
                this.isOptedOutFromBulkEmailField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object lastModifiedDate {
            get {
                return this.lastModifiedDateField;
            }
            set {
                this.lastModifiedDateField = value;
            }
        }
        public object lastName {
            get {
                return this.lastNameField;
            }
            set {
                this.lastNameField = value;
            }
        }
        public object linkedInUrl {
            get {
                return this.linkedInUrlField;
            }
            set {
                this.linkedInUrlField = value;
            }
        }
        public object middleInitial {
            get {
                return this.middleInitialField;
            }
            set {
                this.middleInitialField = value;
            }
        }
        public object mobilePhone {
            get {
                return this.mobilePhoneField;
            }
            set {
                this.mobilePhoneField = value;
            }
        }
        public object namePrefix {
            get {
                return this.namePrefixField;
            }
            set {
                this.namePrefixField = value;
            }
        }
        public object nameSuffix {
            get {
                return this.nameSuffixField;
            }
            set {
                this.nameSuffixField = value;
            }
        }
        public object note {
            get {
                return this.noteField;
            }
            set {
                this.noteField = value;
            }
        }
        public object receivesEmailNotifications {
            get {
                return this.receivesEmailNotificationsField;
            }
            set {
                this.receivesEmailNotificationsField = value;
            }
        }
        public object phone {
            get {
                return this.phoneField;
            }
            set {
                this.phoneField = value;
            }
        }
        public object primaryContact {
            get {
                return this.primaryContactField;
            }
            set {
                this.primaryContactField = value;
            }
        }
        public object roomNumber {
            get {
                return this.roomNumberField;
            }
            set {
                this.roomNumberField = value;
            }
        }
        public object solicitationOptOut {
            get {
                return this.solicitationOptOutField;
            }
            set {
                this.solicitationOptOutField = value;
            }
        }
        public object solicitationOptOutTime {
            get {
                return this.solicitationOptOutTimeField;
            }
            set {
                this.solicitationOptOutTimeField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object surveyOptOut {
            get {
                return this.surveyOptOutField;
            }
            set {
                this.surveyOptOutField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object twitterUrl {
            get {
                return this.twitterUrlField;
            }
            set {
                this.twitterUrlField = value;
            }
        }
        public object zipCode {
            get {
                return this.zipCodeField;
            }
            set {
                this.zipCodeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyLocation {

        private object idField;
        private object address1Field;
        private object address2Field;
        private object alternatePhone1Field;
        private object alternatePhone2Field;
        private object cityField;
        private object companyIDField;
        private object countryIDField;
        private object descriptionField;
        private object faxField;
        private object isActiveField;
        private object isPrimaryField;
        private object isTaxExemptField;
        private object overrideCompanyTaxSettingsField;
        private object nameField;
        private object phoneField;
        private object postalCodeField;
        private object roundtripDistanceField;
        private object stateField;
        private object taxRegionIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object address1 {
            get {
                return this.address1Field;
            }
            set {
                this.address1Field = value;
            }
        }
        public object address2 {
            get {
                return this.address2Field;
            }
            set {
                this.address2Field = value;
            }
        }
        public object alternatePhone1 {
            get {
                return this.alternatePhone1Field;
            }
            set {
                this.alternatePhone1Field = value;
            }
        }
        public object alternatePhone2 {
            get {
                return this.alternatePhone2Field;
            }
            set {
                this.alternatePhone2Field = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object countryID {
            get {
                return this.countryIDField;
            }
            set {
                this.countryIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object fax {
            get {
                return this.faxField;
            }
            set {
                this.faxField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isPrimary {
            get {
                return this.isPrimaryField;
            }
            set {
                this.isPrimaryField = value;
            }
        }
        public object isTaxExempt {
            get {
                return this.isTaxExemptField;
            }
            set {
                this.isTaxExemptField = value;
            }
        }
        public object overrideCompanyTaxSettings {
            get {
                return this.overrideCompanyTaxSettingsField;
            }
            set {
                this.overrideCompanyTaxSettingsField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object phone {
            get {
                return this.phoneField;
            }
            set {
                this.phoneField = value;
            }
        }
        public object postalCode {
            get {
                return this.postalCodeField;
            }
            set {
                this.postalCodeField = value;
            }
        }
        public object roundtripDistance {
            get {
                return this.roundtripDistanceField;
            }
            set {
                this.roundtripDistanceField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object taxRegionID {
            get {
                return this.taxRegionIDField;
            }
            set {
                this.taxRegionIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyNoteAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object companyIDField;
        private object companyNoteIDField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object salesOrderIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyNoteID {
            get {
                return this.companyNoteIDField;
            }
            set {
                this.companyNoteIDField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class CompanyNote {

        private object idField;
        private object actionTypeField;
        private object assignedResourceIDField;
        private object companyIDField;
        private object completedDateTimeField;
        private object contactIDField;
        private object createDateTimeField;
        private object endDateTimeField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastModifiedDateField;
        private object nameField;
        private object noteField;
        private object opportunityIDField;
        private object startDateTimeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object actionType {
            get {
                return this.actionTypeField;
            }
            set {
                this.actionTypeField = value;
            }
        }
        public object assignedResourceID {
            get {
                return this.assignedResourceIDField;
            }
            set {
                this.assignedResourceIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object completedDateTime {
            get {
                return this.completedDateTimeField;
            }
            set {
                this.completedDateTimeField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastModifiedDate {
            get {
                return this.lastModifiedDateField;
            }
            set {
                this.lastModifiedDateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object note {
            get {
                return this.noteField;
            }
            set {
                this.noteField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanySiteConfiguration {

        private object idField;
        private object companyIDField;
        private object locationNameField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object locationName {
            get {
                return this.locationNameField;
            }
            set {
                this.locationNameField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyTeam {

        private object idField;
        private object companyIDField;
        private object isAssociatedAsComanagedField;
        private object resourceIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object isAssociatedAsComanaged {
            get {
                return this.isAssociatedAsComanagedField;
            }
            set {
                this.isAssociatedAsComanagedField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyToDo {

        private object idField;
        private object actionTypeField;
        private object activityDescriptionField;
        private object assignedToResourceIDField;
        private object companyIDField;
        private object completedDateField;
        private object contactIDField;
        private object contractIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object endDateTimeField;
        private object impersonatorCreatorResourceIDField;
        private object lastModifiedDateField;
        private object opportunityIDField;
        private object startDateTimeField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object actionType {
            get {
                return this.actionTypeField;
            }
            set {
                this.actionTypeField = value;
            }
        }
        public object activityDescription {
            get {
                return this.activityDescriptionField;
            }
            set {
                this.activityDescriptionField = value;
            }
        }
        public object assignedToResourceID {
            get {
                return this.assignedToResourceIDField;
            }
            set {
                this.assignedToResourceIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object completedDate {
            get {
                return this.completedDateField;
            }
            set {
                this.completedDateField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object lastModifiedDate {
            get {
                return this.lastModifiedDateField;
            }
            set {
                this.lastModifiedDateField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyWebhookExcludedResource {

        private object idField;
        private object resourceIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyWebhookField {

        private object idField;
        private object fieldIDField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object fieldID {
            get {
                return this.fieldIDField;
            }
            set {
                this.fieldIDField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyWebhook {

        private object idField;
        private object deactivationUrlField;
        private object isActiveField;
        private object isReadyField;
        private object isSubscribedToCreateEventsField;
        private object isSubscribedToDeleteEventsField;
        private object isSubscribedToUpdateEventsField;
        private object nameField;
        private object notificationEmailAddressField;
        private object ownerResourceIDField;
        private object secretKeyField;
        private object sendThresholdExceededNotificationField;
        private object webhookGUIDField;
        private object webhookUrlField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object deactivationUrl {
            get {
                return this.deactivationUrlField;
            }
            set {
                this.deactivationUrlField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isReady {
            get {
                return this.isReadyField;
            }
            set {
                this.isReadyField = value;
            }
        }
        public object isSubscribedToCreateEvents {
            get {
                return this.isSubscribedToCreateEventsField;
            }
            set {
                this.isSubscribedToCreateEventsField = value;
            }
        }
        public object isSubscribedToDeleteEvents {
            get {
                return this.isSubscribedToDeleteEventsField;
            }
            set {
                this.isSubscribedToDeleteEventsField = value;
            }
        }
        public object isSubscribedToUpdateEvents {
            get {
                return this.isSubscribedToUpdateEventsField;
            }
            set {
                this.isSubscribedToUpdateEventsField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notificationEmailAddress {
            get {
                return this.notificationEmailAddressField;
            }
            set {
                this.notificationEmailAddressField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object secretKey {
            get {
                return this.secretKeyField;
            }
            set {
                this.secretKeyField = value;
            }
        }
        public object sendThresholdExceededNotification {
            get {
                return this.sendThresholdExceededNotificationField;
            }
            set {
                this.sendThresholdExceededNotificationField = value;
            }
        }
        public object webhookGUID {
            get {
                return this.webhookGUIDField;
            }
            set {
                this.webhookGUIDField = value;
            }
        }
        public object webhookUrl {
            get {
                return this.webhookUrlField;
            }
            set {
                this.webhookUrlField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class CompanyWebhookUdfField {

        private object idField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object udfFieldIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object udfFieldID {
            get {
                return this.udfFieldIDField;
            }
            set {
                this.udfFieldIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object configurationItemIDField;
        private object configurationItemNoteIDField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object configurationItemNoteID {
            get {
                return this.configurationItemNoteIDField;
            }
            set {
                this.configurationItemNoteIDField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ConfigurationItemBillingProductAssociation {

        private object idField;
        private object billingProductIDField;
        private object configurationItemIDField;
        private object effectiveDateField;
        private object expirationDateField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingProductID {
            get {
                return this.billingProductIDField;
            }
            set {
                this.billingProductIDField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object expirationDate {
            get {
                return this.expirationDateField;
            }
            set {
                this.expirationDateField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemCategory {

        private object idField;
        private object displayColorRGBField;
        private object isActiveField;
        private object isClientPortalDefaultField;
        private object isGlobalDefaultField;
        private object nameField;
        private object nicknameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object displayColorRGB {
            get {
                return this.displayColorRGBField;
            }
            set {
                this.displayColorRGBField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isClientPortalDefault {
            get {
                return this.isClientPortalDefaultField;
            }
            set {
                this.isClientPortalDefaultField = value;
            }
        }
        public object isGlobalDefault {
            get {
                return this.isGlobalDefaultField;
            }
            set {
                this.isGlobalDefaultField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object nickname {
            get {
                return this.nicknameField;
            }
            set {
                this.nicknameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemCategoryUdfAssociation {

        private object idField;
        private object configurationItemCategoryIDField;
        private object isRequiredField;
        private object userDefinedFieldDefinitionIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemCategoryID {
            get {
                return this.configurationItemCategoryIDField;
            }
            set {
                this.configurationItemCategoryIDField = value;
            }
        }
        public object isRequired {
            get {
                return this.isRequiredField;
            }
            set {
                this.isRequiredField = value;
            }
        }
        public object userDefinedFieldDefinitionID {
            get {
                return this.userDefinedFieldDefinitionIDField;
            }
            set {
                this.userDefinedFieldDefinitionIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemExt {

        private object idField;
        private object apiVendorIDField;
        private object companyIDField;
        private object companyLocationIDField;
        private object configurationItemCategoryIDField;
        private object configurationItemTypeField;
        private object contactIDField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object createdByPersonIDField;
        private object dailyCostField;
        private object dattoAvailableKilobytesField;
        private object dattoDeviceMemoryMegabytesField;
        private object dattoDrivesErrorsField;
        private object dattoHostnameField;
        private object dattoInternalIPField;
        private object dattoKernelVersionIDField;
        private object dattoLastCheckInDateTimeField;
        private object dattoNICSpeedKilobitsPerSecondField;
        private object dattoNumberOfAgentsField;
        private object dattoNumberOfDrivesField;
        private object dattoNumberOfVolumesField;
        private object dattoOffsiteUsedBytesField;
        private object dattoOSVersionIDField;
        private object dattoPercentageUsedField;
        private object dattoProtectedKilobytesField;
        private object dattoRemoteIPField;
        private object dattoSerialNumberField;
        private object dattoUptimeSecondsField;
        private object dattoUsedKilobytesField;
        private object dattoZFSVersionIDField;
        private object deviceNetworkingIDField;
        private object domainField;
        private object domainRegistrarIDField;
        private object domainRegistrationDateTimeField;
        private object domainLastUpdatedDateTimeField;
        private object domainExpirationDateTimeField;
        private object hourlyCostField;
        private object impersonatorCreatorResourceIDField;
        private object installDateField;
        private object installedByContactIDField;
        private object installedByIDField;
        private object isActiveField;
        private object lastActivityPersonIDField;
        private object lastActivityPersonTypeField;
        private object lastModifiedTimeField;
        private object locationField;
        private object monthlyCostField;
        private object notesField;
        private object numberOfUsersField;
        private object parentConfigurationItemIDField;
        private object perUseCostField;
        private object productIDField;
        private object referenceNumberField;
        private object referenceTitleField;
        private object rmmDeviceAuditAntivirusStatusIDField;
        private object rmmDeviceAuditArchitectureIDField;
        private object rmmDeviceAuditBackupStatusIDField;
        private object rmmDeviceAuditDescriptionField;
        private object rmmDeviceAuditDeviceTypeIDField;
        private object rmmDeviceAuditDisplayAdaptorIDField;
        private object rmmDeviceAuditDomainIDField;
        private object rmmDeviceAuditExternalIPAddressField;
        private object rmmDeviceAuditHostnameField;
        private object rmmDeviceAuditIPAddressField;
        private object rmmDeviceAuditLastUserField;
        private object rmmDeviceAuditMacAddressField;
        private object rmmDeviceAuditManufacturerIDField;
        private object rmmDeviceAuditMemoryBytesField;
        private object rmmDeviceAuditMissingPatchCountField;
        private object rmmDeviceAuditMobileNetworkOperatorIDField;
        private object rmmDeviceAuditMobileNumberField;
        private object rmmDeviceAuditModelIDField;
        private object rmmDeviceAuditMotherboardIDField;
        private object rmmDeviceAuditOperatingSystemIDField;
        private object rmmDeviceAuditOperatingSystemNameIDField;
        private object rmmDeviceAuditOperatingSystemVersionIDField;
        private object rmmDeviceAuditPatchStatusIDField;
        private object rmmDeviceAuditProcessorIDField;
        private object rmmDeviceAuditServicePackIDField;
        private object rmmDeviceAuditSNMPContactField;
        private object rmmDeviceAuditSNMPLocationField;
        private object rmmDeviceAuditSNMPNameField;
        private object rmmDeviceAuditSoftwareStatusIDField;
        private object rmmDeviceAuditStorageBytesField;
        private object rmmDeviceIDField;
        private object rmmDeviceUIDField;
        private object rmmOpenAlertCountField;
        private object serialNumberField;
        private object serviceBundleIDField;
        private object serviceIDField;
        private object serviceLevelAgreementIDField;
        private object setupFeeField;
        private object sourceChargeIDField;
        private object sourceChargeTypeField;
        private object sslSourceField;
        private object sslCommonNameField;
        private object sslValidFromDateTimeField;
        private object sslValidUntilDateTimeField;
        private object sslIssuedByField;
        private object sslOrganizationField;
        private object sslOrganizationUnitField;
        private object sslLocationField;
        private object sslSerialNumberField;
        private object sslSignatureAlgorithmField;
        private object vendorIDField;
        private object warrantyExpirationDateField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object apiVendorID {
            get {
                return this.apiVendorIDField;
            }
            set {
                this.apiVendorIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object configurationItemCategoryID {
            get {
                return this.configurationItemCategoryIDField;
            }
            set {
                this.configurationItemCategoryIDField = value;
            }
        }
        public object configurationItemType {
            get {
                return this.configurationItemTypeField;
            }
            set {
                this.configurationItemTypeField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object createdByPersonID {
            get {
                return this.createdByPersonIDField;
            }
            set {
                this.createdByPersonIDField = value;
            }
        }
        public object dailyCost {
            get {
                return this.dailyCostField;
            }
            set {
                this.dailyCostField = value;
            }
        }
        public object dattoAvailableKilobytes {
            get {
                return this.dattoAvailableKilobytesField;
            }
            set {
                this.dattoAvailableKilobytesField = value;
            }
        }
        public object dattoDeviceMemoryMegabytes {
            get {
                return this.dattoDeviceMemoryMegabytesField;
            }
            set {
                this.dattoDeviceMemoryMegabytesField = value;
            }
        }
        public object dattoDrivesErrors {
            get {
                return this.dattoDrivesErrorsField;
            }
            set {
                this.dattoDrivesErrorsField = value;
            }
        }
        public object dattoHostname {
            get {
                return this.dattoHostnameField;
            }
            set {
                this.dattoHostnameField = value;
            }
        }
        public object dattoInternalIP {
            get {
                return this.dattoInternalIPField;
            }
            set {
                this.dattoInternalIPField = value;
            }
        }
        public object dattoKernelVersionID {
            get {
                return this.dattoKernelVersionIDField;
            }
            set {
                this.dattoKernelVersionIDField = value;
            }
        }
        public object dattoLastCheckInDateTime {
            get {
                return this.dattoLastCheckInDateTimeField;
            }
            set {
                this.dattoLastCheckInDateTimeField = value;
            }
        }
        public object dattoNICSpeedKilobitsPerSecond {
            get {
                return this.dattoNICSpeedKilobitsPerSecondField;
            }
            set {
                this.dattoNICSpeedKilobitsPerSecondField = value;
            }
        }
        public object dattoNumberOfAgents {
            get {
                return this.dattoNumberOfAgentsField;
            }
            set {
                this.dattoNumberOfAgentsField = value;
            }
        }
        public object dattoNumberOfDrives {
            get {
                return this.dattoNumberOfDrivesField;
            }
            set {
                this.dattoNumberOfDrivesField = value;
            }
        }
        public object dattoNumberOfVolumes {
            get {
                return this.dattoNumberOfVolumesField;
            }
            set {
                this.dattoNumberOfVolumesField = value;
            }
        }
        public object dattoOffsiteUsedBytes {
            get {
                return this.dattoOffsiteUsedBytesField;
            }
            set {
                this.dattoOffsiteUsedBytesField = value;
            }
        }
        public object dattoOSVersionID {
            get {
                return this.dattoOSVersionIDField;
            }
            set {
                this.dattoOSVersionIDField = value;
            }
        }
        public object dattoPercentageUsed {
            get {
                return this.dattoPercentageUsedField;
            }
            set {
                this.dattoPercentageUsedField = value;
            }
        }
        public object dattoProtectedKilobytes {
            get {
                return this.dattoProtectedKilobytesField;
            }
            set {
                this.dattoProtectedKilobytesField = value;
            }
        }
        public object dattoRemoteIP {
            get {
                return this.dattoRemoteIPField;
            }
            set {
                this.dattoRemoteIPField = value;
            }
        }
        public object dattoSerialNumber {
            get {
                return this.dattoSerialNumberField;
            }
            set {
                this.dattoSerialNumberField = value;
            }
        }
        public object dattoUptimeSeconds {
            get {
                return this.dattoUptimeSecondsField;
            }
            set {
                this.dattoUptimeSecondsField = value;
            }
        }
        public object dattoUsedKilobytes {
            get {
                return this.dattoUsedKilobytesField;
            }
            set {
                this.dattoUsedKilobytesField = value;
            }
        }
        public object dattoZFSVersionID {
            get {
                return this.dattoZFSVersionIDField;
            }
            set {
                this.dattoZFSVersionIDField = value;
            }
        }
        public object deviceNetworkingID {
            get {
                return this.deviceNetworkingIDField;
            }
            set {
                this.deviceNetworkingIDField = value;
            }
        }
        public object domain {
            get {
                return this.domainField;
            }
            set {
                this.domainField = value;
            }
        }
        public object domainRegistrarID {
            get {
                return this.domainRegistrarIDField;
            }
            set {
                this.domainRegistrarIDField = value;
            }
        }
        public object domainRegistrationDateTime {
            get {
                return this.domainRegistrationDateTimeField;
            }
            set {
                this.domainRegistrationDateTimeField = value;
            }
        }
        public object domainLastUpdatedDateTime {
            get {
                return this.domainLastUpdatedDateTimeField;
            }
            set {
                this.domainLastUpdatedDateTimeField = value;
            }
        }
        public object domainExpirationDateTime {
            get {
                return this.domainExpirationDateTimeField;
            }
            set {
                this.domainExpirationDateTimeField = value;
            }
        }
        public object hourlyCost {
            get {
                return this.hourlyCostField;
            }
            set {
                this.hourlyCostField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object installDate {
            get {
                return this.installDateField;
            }
            set {
                this.installDateField = value;
            }
        }
        public object installedByContactID {
            get {
                return this.installedByContactIDField;
            }
            set {
                this.installedByContactIDField = value;
            }
        }
        public object installedByID {
            get {
                return this.installedByIDField;
            }
            set {
                this.installedByIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastActivityPersonID {
            get {
                return this.lastActivityPersonIDField;
            }
            set {
                this.lastActivityPersonIDField = value;
            }
        }
        public object lastActivityPersonType {
            get {
                return this.lastActivityPersonTypeField;
            }
            set {
                this.lastActivityPersonTypeField = value;
            }
        }
        public object lastModifiedTime {
            get {
                return this.lastModifiedTimeField;
            }
            set {
                this.lastModifiedTimeField = value;
            }
        }
        public object location {
            get {
                return this.locationField;
            }
            set {
                this.locationField = value;
            }
        }
        public object monthlyCost {
            get {
                return this.monthlyCostField;
            }
            set {
                this.monthlyCostField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object numberOfUsers {
            get {
                return this.numberOfUsersField;
            }
            set {
                this.numberOfUsersField = value;
            }
        }
        public object parentConfigurationItemID {
            get {
                return this.parentConfigurationItemIDField;
            }
            set {
                this.parentConfigurationItemIDField = value;
            }
        }
        public object perUseCost {
            get {
                return this.perUseCostField;
            }
            set {
                this.perUseCostField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object referenceNumber {
            get {
                return this.referenceNumberField;
            }
            set {
                this.referenceNumberField = value;
            }
        }
        public object referenceTitle {
            get {
                return this.referenceTitleField;
            }
            set {
                this.referenceTitleField = value;
            }
        }
        public object rmmDeviceAuditAntivirusStatusID {
            get {
                return this.rmmDeviceAuditAntivirusStatusIDField;
            }
            set {
                this.rmmDeviceAuditAntivirusStatusIDField = value;
            }
        }
        public object rmmDeviceAuditArchitectureID {
            get {
                return this.rmmDeviceAuditArchitectureIDField;
            }
            set {
                this.rmmDeviceAuditArchitectureIDField = value;
            }
        }
        public object rmmDeviceAuditBackupStatusID {
            get {
                return this.rmmDeviceAuditBackupStatusIDField;
            }
            set {
                this.rmmDeviceAuditBackupStatusIDField = value;
            }
        }
        public object rmmDeviceAuditDescription {
            get {
                return this.rmmDeviceAuditDescriptionField;
            }
            set {
                this.rmmDeviceAuditDescriptionField = value;
            }
        }
        public object rmmDeviceAuditDeviceTypeID {
            get {
                return this.rmmDeviceAuditDeviceTypeIDField;
            }
            set {
                this.rmmDeviceAuditDeviceTypeIDField = value;
            }
        }
        public object rmmDeviceAuditDisplayAdaptorID {
            get {
                return this.rmmDeviceAuditDisplayAdaptorIDField;
            }
            set {
                this.rmmDeviceAuditDisplayAdaptorIDField = value;
            }
        }
        public object rmmDeviceAuditDomainID {
            get {
                return this.rmmDeviceAuditDomainIDField;
            }
            set {
                this.rmmDeviceAuditDomainIDField = value;
            }
        }
        public object rmmDeviceAuditExternalIPAddress {
            get {
                return this.rmmDeviceAuditExternalIPAddressField;
            }
            set {
                this.rmmDeviceAuditExternalIPAddressField = value;
            }
        }
        public object rmmDeviceAuditHostname {
            get {
                return this.rmmDeviceAuditHostnameField;
            }
            set {
                this.rmmDeviceAuditHostnameField = value;
            }
        }
        public object rmmDeviceAuditIPAddress {
            get {
                return this.rmmDeviceAuditIPAddressField;
            }
            set {
                this.rmmDeviceAuditIPAddressField = value;
            }
        }
        public object rmmDeviceAuditLastUser {
            get {
                return this.rmmDeviceAuditLastUserField;
            }
            set {
                this.rmmDeviceAuditLastUserField = value;
            }
        }
        public object rmmDeviceAuditMacAddress {
            get {
                return this.rmmDeviceAuditMacAddressField;
            }
            set {
                this.rmmDeviceAuditMacAddressField = value;
            }
        }
        public object rmmDeviceAuditManufacturerID {
            get {
                return this.rmmDeviceAuditManufacturerIDField;
            }
            set {
                this.rmmDeviceAuditManufacturerIDField = value;
            }
        }
        public object rmmDeviceAuditMemoryBytes {
            get {
                return this.rmmDeviceAuditMemoryBytesField;
            }
            set {
                this.rmmDeviceAuditMemoryBytesField = value;
            }
        }
        public object rmmDeviceAuditMissingPatchCount {
            get {
                return this.rmmDeviceAuditMissingPatchCountField;
            }
            set {
                this.rmmDeviceAuditMissingPatchCountField = value;
            }
        }
        public object rmmDeviceAuditMobileNetworkOperatorID {
            get {
                return this.rmmDeviceAuditMobileNetworkOperatorIDField;
            }
            set {
                this.rmmDeviceAuditMobileNetworkOperatorIDField = value;
            }
        }
        public object rmmDeviceAuditMobileNumber {
            get {
                return this.rmmDeviceAuditMobileNumberField;
            }
            set {
                this.rmmDeviceAuditMobileNumberField = value;
            }
        }
        public object rmmDeviceAuditModelID {
            get {
                return this.rmmDeviceAuditModelIDField;
            }
            set {
                this.rmmDeviceAuditModelIDField = value;
            }
        }
        public object rmmDeviceAuditMotherboardID {
            get {
                return this.rmmDeviceAuditMotherboardIDField;
            }
            set {
                this.rmmDeviceAuditMotherboardIDField = value;
            }
        }
        public object rmmDeviceAuditOperatingSystemID {
            get {
                return this.rmmDeviceAuditOperatingSystemIDField;
            }
            set {
                this.rmmDeviceAuditOperatingSystemIDField = value;
            }
        }
        public object rmmDeviceAuditOperatingSystemNameID {
            get {
                return this.rmmDeviceAuditOperatingSystemNameIDField;
            }
            set {
                this.rmmDeviceAuditOperatingSystemNameIDField = value;
            }
        }
        public object rmmDeviceAuditOperatingSystemVersionID {
            get {
                return this.rmmDeviceAuditOperatingSystemVersionIDField;
            }
            set {
                this.rmmDeviceAuditOperatingSystemVersionIDField = value;
            }
        }
        public object rmmDeviceAuditPatchStatusID {
            get {
                return this.rmmDeviceAuditPatchStatusIDField;
            }
            set {
                this.rmmDeviceAuditPatchStatusIDField = value;
            }
        }
        public object rmmDeviceAuditProcessorID {
            get {
                return this.rmmDeviceAuditProcessorIDField;
            }
            set {
                this.rmmDeviceAuditProcessorIDField = value;
            }
        }
        public object rmmDeviceAuditServicePackID {
            get {
                return this.rmmDeviceAuditServicePackIDField;
            }
            set {
                this.rmmDeviceAuditServicePackIDField = value;
            }
        }
        public object rmmDeviceAuditSNMPContact {
            get {
                return this.rmmDeviceAuditSNMPContactField;
            }
            set {
                this.rmmDeviceAuditSNMPContactField = value;
            }
        }
        public object rmmDeviceAuditSNMPLocation {
            get {
                return this.rmmDeviceAuditSNMPLocationField;
            }
            set {
                this.rmmDeviceAuditSNMPLocationField = value;
            }
        }
        public object rmmDeviceAuditSNMPName {
            get {
                return this.rmmDeviceAuditSNMPNameField;
            }
            set {
                this.rmmDeviceAuditSNMPNameField = value;
            }
        }
        public object rmmDeviceAuditSoftwareStatusID {
            get {
                return this.rmmDeviceAuditSoftwareStatusIDField;
            }
            set {
                this.rmmDeviceAuditSoftwareStatusIDField = value;
            }
        }
        public object rmmDeviceAuditStorageBytes {
            get {
                return this.rmmDeviceAuditStorageBytesField;
            }
            set {
                this.rmmDeviceAuditStorageBytesField = value;
            }
        }
        public object rmmDeviceID {
            get {
                return this.rmmDeviceIDField;
            }
            set {
                this.rmmDeviceIDField = value;
            }
        }
        public object rmmDeviceUID {
            get {
                return this.rmmDeviceUIDField;
            }
            set {
                this.rmmDeviceUIDField = value;
            }
        }
        public object rmmOpenAlertCount {
            get {
                return this.rmmOpenAlertCountField;
            }
            set {
                this.rmmOpenAlertCountField = value;
            }
        }
        public object serialNumber {
            get {
                return this.serialNumberField;
            }
            set {
                this.serialNumberField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object setupFee {
            get {
                return this.setupFeeField;
            }
            set {
                this.setupFeeField = value;
            }
        }
        public object sourceChargeID {
            get {
                return this.sourceChargeIDField;
            }
            set {
                this.sourceChargeIDField = value;
            }
        }
        public object sourceChargeType {
            get {
                return this.sourceChargeTypeField;
            }
            set {
                this.sourceChargeTypeField = value;
            }
        }
        public object sslSource {
            get {
                return this.sslSourceField;
            }
            set {
                this.sslSourceField = value;
            }
        }
        public object sslCommonName {
            get {
                return this.sslCommonNameField;
            }
            set {
                this.sslCommonNameField = value;
            }
        }
        public object sslValidFromDateTime {
            get {
                return this.sslValidFromDateTimeField;
            }
            set {
                this.sslValidFromDateTimeField = value;
            }
        }
        public object sslValidUntilDateTime {
            get {
                return this.sslValidUntilDateTimeField;
            }
            set {
                this.sslValidUntilDateTimeField = value;
            }
        }
        public object sslIssuedBy {
            get {
                return this.sslIssuedByField;
            }
            set {
                this.sslIssuedByField = value;
            }
        }
        public object sslOrganization {
            get {
                return this.sslOrganizationField;
            }
            set {
                this.sslOrganizationField = value;
            }
        }
        public object sslOrganizationUnit {
            get {
                return this.sslOrganizationUnitField;
            }
            set {
                this.sslOrganizationUnitField = value;
            }
        }
        public object sslLocation {
            get {
                return this.sslLocationField;
            }
            set {
                this.sslLocationField = value;
            }
        }
        public object sslSerialNumber {
            get {
                return this.sslSerialNumberField;
            }
            set {
                this.sslSerialNumberField = value;
            }
        }
        public object sslSignatureAlgorithm {
            get {
                return this.sslSignatureAlgorithmField;
            }
            set {
                this.sslSignatureAlgorithmField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object warrantyExpirationDate {
            get {
                return this.warrantyExpirationDateField;
            }
            set {
                this.warrantyExpirationDateField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemNoteAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object configurationItemIDField;
        private object configurationItemNoteIDField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object configurationItemNoteID {
            get {
                return this.configurationItemNoteIDField;
            }
            set {
                this.configurationItemNoteIDField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ConfigurationItemNote {

        private object idField;
        private object configurationItemIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastActivityDateField;
        private object noteTypeField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object noteType {
            get {
                return this.noteTypeField;
            }
            set {
                this.noteTypeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemRelatedItem {

        private object idField;
        private object configurationItemIDField;
        private object relatedConfigurationItemIDField;
        private object relationshipField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object relatedConfigurationItemID {
            get {
                return this.relatedConfigurationItemIDField;
            }
            set {
                this.relatedConfigurationItemIDField = value;
            }
        }
        public object relationship {
            get {
                return this.relationshipField;
            }
            set {
                this.relationshipField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItem {

        private object idField;
        private object apiVendorIDField;
        private object configurationItemCategoryIDField;
        private object companyIDField;
        private object companyLocationIDField;
        private object configurationItemTypeField;
        private object contactIDField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object createdByPersonIDField;
        private object dailyCostField;
        private object dattoAvailableKilobytesField;
        private object dattoDeviceMemoryMegabytesField;
        private object dattoDrivesErrorsField;
        private object dattoHostnameField;
        private object dattoInternalIPField;
        private object dattoKernelVersionIDField;
        private object dattoLastCheckInDateTimeField;
        private object dattoNICSpeedKilobitsPerSecondField;
        private object dattoNumberOfAgentsField;
        private object dattoNumberOfDrivesField;
        private object dattoNumberOfVolumesField;
        private object dattoOffsiteUsedBytesField;
        private object dattoOSVersionIDField;
        private object dattoPercentageUsedField;
        private object dattoProtectedKilobytesField;
        private object dattoRemoteIPField;
        private object dattoSerialNumberField;
        private object dattoUptimeSecondsField;
        private object dattoUsedKilobytesField;
        private object dattoZFSVersionIDField;
        private object deviceNetworkingIDField;
        private object domainField;
        private object domainRegistrarIDField;
        private object domainRegistrationDateTimeField;
        private object domainLastUpdatedDateTimeField;
        private object domainExpirationDateTimeField;
        private object hourlyCostField;
        private object impersonatorCreatorResourceIDField;
        private object installDateField;
        private object installedByContactIDField;
        private object installedByIDField;
        private object isActiveField;
        private object lastActivityPersonIDField;
        private object lastActivityPersonTypeField;
        private object lastModifiedTimeField;
        private object locationField;
        private object monthlyCostField;
        private object notesField;
        private object numberOfUsersField;
        private object parentConfigurationItemIDField;
        private object perUseCostField;
        private object productIDField;
        private object referenceNumberField;
        private object referenceTitleField;
        private object rmmDeviceAuditAntivirusStatusIDField;
        private object rmmDeviceAuditArchitectureIDField;
        private object rmmDeviceAuditBackupStatusIDField;
        private object rmmDeviceAuditDescriptionField;
        private object rmmDeviceAuditDeviceTypeIDField;
        private object rmmDeviceAuditDisplayAdaptorIDField;
        private object rmmDeviceAuditDomainIDField;
        private object rmmDeviceAuditExternalIPAddressField;
        private object rmmDeviceAuditHostnameField;
        private object rmmDeviceAuditIPAddressField;
        private object rmmDeviceAuditLastUserField;
        private object rmmDeviceAuditMacAddressField;
        private object rmmDeviceAuditManufacturerIDField;
        private object rmmDeviceAuditMemoryBytesField;
        private object rmmDeviceAuditMissingPatchCountField;
        private object rmmDeviceAuditMobileNetworkOperatorIDField;
        private object rmmDeviceAuditMobileNumberField;
        private object rmmDeviceAuditModelIDField;
        private object rmmDeviceAuditMotherboardIDField;
        private object rmmDeviceAuditOperatingSystemField;
        private object rmmDeviceAuditPatchStatusIDField;
        private object rmmDeviceAuditProcessorIDField;
        private object rmmDeviceAuditServicePackIDField;
        private object rmmDeviceAuditSNMPContactField;
        private object rmmDeviceAuditSNMPLocationField;
        private object rmmDeviceAuditSNMPNameField;
        private object rmmDeviceAuditSoftwareStatusIDField;
        private object rmmDeviceAuditStorageBytesField;
        private object rmmDeviceIDField;
        private object rmmDeviceUIDField;
        private object rmmOpenAlertCountField;
        private object serialNumberField;
        private object serviceBundleIDField;
        private object serviceIDField;
        private object serviceLevelAgreementIDField;
        private object setupFeeField;
        private object sourceChargeIDField;
        private object sourceChargeTypeField;
        private object sslSourceField;
        private object sslCommonNameField;
        private object sslValidFromDateTimeField;
        private object sslValidUntilDateTimeField;
        private object sslIssuedByField;
        private object sslOrganizationField;
        private object sslOrganizationUnitField;
        private object sslLocationField;
        private object sslSerialNumberField;
        private object sslSignatureAlgorithmField;
        private object vendorIDField;
        private object warrantyExpirationDateField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object apiVendorID {
            get {
                return this.apiVendorIDField;
            }
            set {
                this.apiVendorIDField = value;
            }
        }
        public object configurationItemCategoryID {
            get {
                return this.configurationItemCategoryIDField;
            }
            set {
                this.configurationItemCategoryIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object configurationItemType {
            get {
                return this.configurationItemTypeField;
            }
            set {
                this.configurationItemTypeField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object createdByPersonID {
            get {
                return this.createdByPersonIDField;
            }
            set {
                this.createdByPersonIDField = value;
            }
        }
        public object dailyCost {
            get {
                return this.dailyCostField;
            }
            set {
                this.dailyCostField = value;
            }
        }
        public object dattoAvailableKilobytes {
            get {
                return this.dattoAvailableKilobytesField;
            }
            set {
                this.dattoAvailableKilobytesField = value;
            }
        }
        public object dattoDeviceMemoryMegabytes {
            get {
                return this.dattoDeviceMemoryMegabytesField;
            }
            set {
                this.dattoDeviceMemoryMegabytesField = value;
            }
        }
        public object dattoDrivesErrors {
            get {
                return this.dattoDrivesErrorsField;
            }
            set {
                this.dattoDrivesErrorsField = value;
            }
        }
        public object dattoHostname {
            get {
                return this.dattoHostnameField;
            }
            set {
                this.dattoHostnameField = value;
            }
        }
        public object dattoInternalIP {
            get {
                return this.dattoInternalIPField;
            }
            set {
                this.dattoInternalIPField = value;
            }
        }
        public object dattoKernelVersionID {
            get {
                return this.dattoKernelVersionIDField;
            }
            set {
                this.dattoKernelVersionIDField = value;
            }
        }
        public object dattoLastCheckInDateTime {
            get {
                return this.dattoLastCheckInDateTimeField;
            }
            set {
                this.dattoLastCheckInDateTimeField = value;
            }
        }
        public object dattoNICSpeedKilobitsPerSecond {
            get {
                return this.dattoNICSpeedKilobitsPerSecondField;
            }
            set {
                this.dattoNICSpeedKilobitsPerSecondField = value;
            }
        }
        public object dattoNumberOfAgents {
            get {
                return this.dattoNumberOfAgentsField;
            }
            set {
                this.dattoNumberOfAgentsField = value;
            }
        }
        public object dattoNumberOfDrives {
            get {
                return this.dattoNumberOfDrivesField;
            }
            set {
                this.dattoNumberOfDrivesField = value;
            }
        }
        public object dattoNumberOfVolumes {
            get {
                return this.dattoNumberOfVolumesField;
            }
            set {
                this.dattoNumberOfVolumesField = value;
            }
        }
        public object dattoOffsiteUsedBytes {
            get {
                return this.dattoOffsiteUsedBytesField;
            }
            set {
                this.dattoOffsiteUsedBytesField = value;
            }
        }
        public object dattoOSVersionID {
            get {
                return this.dattoOSVersionIDField;
            }
            set {
                this.dattoOSVersionIDField = value;
            }
        }
        public object dattoPercentageUsed {
            get {
                return this.dattoPercentageUsedField;
            }
            set {
                this.dattoPercentageUsedField = value;
            }
        }
        public object dattoProtectedKilobytes {
            get {
                return this.dattoProtectedKilobytesField;
            }
            set {
                this.dattoProtectedKilobytesField = value;
            }
        }
        public object dattoRemoteIP {
            get {
                return this.dattoRemoteIPField;
            }
            set {
                this.dattoRemoteIPField = value;
            }
        }
        public object dattoSerialNumber {
            get {
                return this.dattoSerialNumberField;
            }
            set {
                this.dattoSerialNumberField = value;
            }
        }
        public object dattoUptimeSeconds {
            get {
                return this.dattoUptimeSecondsField;
            }
            set {
                this.dattoUptimeSecondsField = value;
            }
        }
        public object dattoUsedKilobytes {
            get {
                return this.dattoUsedKilobytesField;
            }
            set {
                this.dattoUsedKilobytesField = value;
            }
        }
        public object dattoZFSVersionID {
            get {
                return this.dattoZFSVersionIDField;
            }
            set {
                this.dattoZFSVersionIDField = value;
            }
        }
        public object deviceNetworkingID {
            get {
                return this.deviceNetworkingIDField;
            }
            set {
                this.deviceNetworkingIDField = value;
            }
        }
        public object domain {
            get {
                return this.domainField;
            }
            set {
                this.domainField = value;
            }
        }
        public object domainRegistrarID {
            get {
                return this.domainRegistrarIDField;
            }
            set {
                this.domainRegistrarIDField = value;
            }
        }
        public object domainRegistrationDateTime {
            get {
                return this.domainRegistrationDateTimeField;
            }
            set {
                this.domainRegistrationDateTimeField = value;
            }
        }
        public object domainLastUpdatedDateTime {
            get {
                return this.domainLastUpdatedDateTimeField;
            }
            set {
                this.domainLastUpdatedDateTimeField = value;
            }
        }
        public object domainExpirationDateTime {
            get {
                return this.domainExpirationDateTimeField;
            }
            set {
                this.domainExpirationDateTimeField = value;
            }
        }
        public object hourlyCost {
            get {
                return this.hourlyCostField;
            }
            set {
                this.hourlyCostField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object installDate {
            get {
                return this.installDateField;
            }
            set {
                this.installDateField = value;
            }
        }
        public object installedByContactID {
            get {
                return this.installedByContactIDField;
            }
            set {
                this.installedByContactIDField = value;
            }
        }
        public object installedByID {
            get {
                return this.installedByIDField;
            }
            set {
                this.installedByIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastActivityPersonID {
            get {
                return this.lastActivityPersonIDField;
            }
            set {
                this.lastActivityPersonIDField = value;
            }
        }
        public object lastActivityPersonType {
            get {
                return this.lastActivityPersonTypeField;
            }
            set {
                this.lastActivityPersonTypeField = value;
            }
        }
        public object lastModifiedTime {
            get {
                return this.lastModifiedTimeField;
            }
            set {
                this.lastModifiedTimeField = value;
            }
        }
        public object location {
            get {
                return this.locationField;
            }
            set {
                this.locationField = value;
            }
        }
        public object monthlyCost {
            get {
                return this.monthlyCostField;
            }
            set {
                this.monthlyCostField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object numberOfUsers {
            get {
                return this.numberOfUsersField;
            }
            set {
                this.numberOfUsersField = value;
            }
        }
        public object parentConfigurationItemID {
            get {
                return this.parentConfigurationItemIDField;
            }
            set {
                this.parentConfigurationItemIDField = value;
            }
        }
        public object perUseCost {
            get {
                return this.perUseCostField;
            }
            set {
                this.perUseCostField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object referenceNumber {
            get {
                return this.referenceNumberField;
            }
            set {
                this.referenceNumberField = value;
            }
        }
        public object referenceTitle {
            get {
                return this.referenceTitleField;
            }
            set {
                this.referenceTitleField = value;
            }
        }
        public object rmmDeviceAuditAntivirusStatusID {
            get {
                return this.rmmDeviceAuditAntivirusStatusIDField;
            }
            set {
                this.rmmDeviceAuditAntivirusStatusIDField = value;
            }
        }
        public object rmmDeviceAuditArchitectureID {
            get {
                return this.rmmDeviceAuditArchitectureIDField;
            }
            set {
                this.rmmDeviceAuditArchitectureIDField = value;
            }
        }
        public object rmmDeviceAuditBackupStatusID {
            get {
                return this.rmmDeviceAuditBackupStatusIDField;
            }
            set {
                this.rmmDeviceAuditBackupStatusIDField = value;
            }
        }
        public object rmmDeviceAuditDescription {
            get {
                return this.rmmDeviceAuditDescriptionField;
            }
            set {
                this.rmmDeviceAuditDescriptionField = value;
            }
        }
        public object rmmDeviceAuditDeviceTypeID {
            get {
                return this.rmmDeviceAuditDeviceTypeIDField;
            }
            set {
                this.rmmDeviceAuditDeviceTypeIDField = value;
            }
        }
        public object rmmDeviceAuditDisplayAdaptorID {
            get {
                return this.rmmDeviceAuditDisplayAdaptorIDField;
            }
            set {
                this.rmmDeviceAuditDisplayAdaptorIDField = value;
            }
        }
        public object rmmDeviceAuditDomainID {
            get {
                return this.rmmDeviceAuditDomainIDField;
            }
            set {
                this.rmmDeviceAuditDomainIDField = value;
            }
        }
        public object rmmDeviceAuditExternalIPAddress {
            get {
                return this.rmmDeviceAuditExternalIPAddressField;
            }
            set {
                this.rmmDeviceAuditExternalIPAddressField = value;
            }
        }
        public object rmmDeviceAuditHostname {
            get {
                return this.rmmDeviceAuditHostnameField;
            }
            set {
                this.rmmDeviceAuditHostnameField = value;
            }
        }
        public object rmmDeviceAuditIPAddress {
            get {
                return this.rmmDeviceAuditIPAddressField;
            }
            set {
                this.rmmDeviceAuditIPAddressField = value;
            }
        }
        public object rmmDeviceAuditLastUser {
            get {
                return this.rmmDeviceAuditLastUserField;
            }
            set {
                this.rmmDeviceAuditLastUserField = value;
            }
        }
        public object rmmDeviceAuditMacAddress {
            get {
                return this.rmmDeviceAuditMacAddressField;
            }
            set {
                this.rmmDeviceAuditMacAddressField = value;
            }
        }
        public object rmmDeviceAuditManufacturerID {
            get {
                return this.rmmDeviceAuditManufacturerIDField;
            }
            set {
                this.rmmDeviceAuditManufacturerIDField = value;
            }
        }
        public object rmmDeviceAuditMemoryBytes {
            get {
                return this.rmmDeviceAuditMemoryBytesField;
            }
            set {
                this.rmmDeviceAuditMemoryBytesField = value;
            }
        }
        public object rmmDeviceAuditMissingPatchCount {
            get {
                return this.rmmDeviceAuditMissingPatchCountField;
            }
            set {
                this.rmmDeviceAuditMissingPatchCountField = value;
            }
        }
        public object rmmDeviceAuditMobileNetworkOperatorID {
            get {
                return this.rmmDeviceAuditMobileNetworkOperatorIDField;
            }
            set {
                this.rmmDeviceAuditMobileNetworkOperatorIDField = value;
            }
        }
        public object rmmDeviceAuditMobileNumber {
            get {
                return this.rmmDeviceAuditMobileNumberField;
            }
            set {
                this.rmmDeviceAuditMobileNumberField = value;
            }
        }
        public object rmmDeviceAuditModelID {
            get {
                return this.rmmDeviceAuditModelIDField;
            }
            set {
                this.rmmDeviceAuditModelIDField = value;
            }
        }
        public object rmmDeviceAuditMotherboardID {
            get {
                return this.rmmDeviceAuditMotherboardIDField;
            }
            set {
                this.rmmDeviceAuditMotherboardIDField = value;
            }
        }
        public object rmmDeviceAuditOperatingSystem {
            get {
                return this.rmmDeviceAuditOperatingSystemField;
            }
            set {
                this.rmmDeviceAuditOperatingSystemField = value;
            }
        }
        public object rmmDeviceAuditPatchStatusID {
            get {
                return this.rmmDeviceAuditPatchStatusIDField;
            }
            set {
                this.rmmDeviceAuditPatchStatusIDField = value;
            }
        }
        public object rmmDeviceAuditProcessorID {
            get {
                return this.rmmDeviceAuditProcessorIDField;
            }
            set {
                this.rmmDeviceAuditProcessorIDField = value;
            }
        }
        public object rmmDeviceAuditServicePackID {
            get {
                return this.rmmDeviceAuditServicePackIDField;
            }
            set {
                this.rmmDeviceAuditServicePackIDField = value;
            }
        }
        public object rmmDeviceAuditSNMPContact {
            get {
                return this.rmmDeviceAuditSNMPContactField;
            }
            set {
                this.rmmDeviceAuditSNMPContactField = value;
            }
        }
        public object rmmDeviceAuditSNMPLocation {
            get {
                return this.rmmDeviceAuditSNMPLocationField;
            }
            set {
                this.rmmDeviceAuditSNMPLocationField = value;
            }
        }
        public object rmmDeviceAuditSNMPName {
            get {
                return this.rmmDeviceAuditSNMPNameField;
            }
            set {
                this.rmmDeviceAuditSNMPNameField = value;
            }
        }
        public object rmmDeviceAuditSoftwareStatusID {
            get {
                return this.rmmDeviceAuditSoftwareStatusIDField;
            }
            set {
                this.rmmDeviceAuditSoftwareStatusIDField = value;
            }
        }
        public object rmmDeviceAuditStorageBytes {
            get {
                return this.rmmDeviceAuditStorageBytesField;
            }
            set {
                this.rmmDeviceAuditStorageBytesField = value;
            }
        }
        public object rmmDeviceID {
            get {
                return this.rmmDeviceIDField;
            }
            set {
                this.rmmDeviceIDField = value;
            }
        }
        public object rmmDeviceUID {
            get {
                return this.rmmDeviceUIDField;
            }
            set {
                this.rmmDeviceUIDField = value;
            }
        }
        public object rmmOpenAlertCount {
            get {
                return this.rmmOpenAlertCountField;
            }
            set {
                this.rmmOpenAlertCountField = value;
            }
        }
        public object serialNumber {
            get {
                return this.serialNumberField;
            }
            set {
                this.serialNumberField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object setupFee {
            get {
                return this.setupFeeField;
            }
            set {
                this.setupFeeField = value;
            }
        }
        public object sourceChargeID {
            get {
                return this.sourceChargeIDField;
            }
            set {
                this.sourceChargeIDField = value;
            }
        }
        public object sourceChargeType {
            get {
                return this.sourceChargeTypeField;
            }
            set {
                this.sourceChargeTypeField = value;
            }
        }
        public object sslSource {
            get {
                return this.sslSourceField;
            }
            set {
                this.sslSourceField = value;
            }
        }
        public object sslCommonName {
            get {
                return this.sslCommonNameField;
            }
            set {
                this.sslCommonNameField = value;
            }
        }
        public object sslValidFromDateTime {
            get {
                return this.sslValidFromDateTimeField;
            }
            set {
                this.sslValidFromDateTimeField = value;
            }
        }
        public object sslValidUntilDateTime {
            get {
                return this.sslValidUntilDateTimeField;
            }
            set {
                this.sslValidUntilDateTimeField = value;
            }
        }
        public object sslIssuedBy {
            get {
                return this.sslIssuedByField;
            }
            set {
                this.sslIssuedByField = value;
            }
        }
        public object sslOrganization {
            get {
                return this.sslOrganizationField;
            }
            set {
                this.sslOrganizationField = value;
            }
        }
        public object sslOrganizationUnit {
            get {
                return this.sslOrganizationUnitField;
            }
            set {
                this.sslOrganizationUnitField = value;
            }
        }
        public object sslLocation {
            get {
                return this.sslLocationField;
            }
            set {
                this.sslLocationField = value;
            }
        }
        public object sslSerialNumber {
            get {
                return this.sslSerialNumberField;
            }
            set {
                this.sslSerialNumberField = value;
            }
        }
        public object sslSignatureAlgorithm {
            get {
                return this.sslSignatureAlgorithmField;
            }
            set {
                this.sslSignatureAlgorithmField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object warrantyExpirationDate {
            get {
                return this.warrantyExpirationDateField;
            }
            set {
                this.warrantyExpirationDateField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemType {

        private object idField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemWebhookExcludedResource {

        private object idField;
        private object resourceIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemWebhookField {

        private object idField;
        private object fieldIDField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object fieldID {
            get {
                return this.fieldIDField;
            }
            set {
                this.fieldIDField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemWebhook {

        private object idField;
        private object deactivationUrlField;
        private object isActiveField;
        private object isReadyField;
        private object isSubscribedToCreateEventsField;
        private object isSubscribedToDeleteEventsField;
        private object isSubscribedToUpdateEventsField;
        private object nameField;
        private object notificationEmailAddressField;
        private object ownerResourceIDField;
        private object secretKeyField;
        private object sendThresholdExceededNotificationField;
        private object webhookGUIDField;
        private object webhookUrlField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object deactivationUrl {
            get {
                return this.deactivationUrlField;
            }
            set {
                this.deactivationUrlField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isReady {
            get {
                return this.isReadyField;
            }
            set {
                this.isReadyField = value;
            }
        }
        public object isSubscribedToCreateEvents {
            get {
                return this.isSubscribedToCreateEventsField;
            }
            set {
                this.isSubscribedToCreateEventsField = value;
            }
        }
        public object isSubscribedToDeleteEvents {
            get {
                return this.isSubscribedToDeleteEventsField;
            }
            set {
                this.isSubscribedToDeleteEventsField = value;
            }
        }
        public object isSubscribedToUpdateEvents {
            get {
                return this.isSubscribedToUpdateEventsField;
            }
            set {
                this.isSubscribedToUpdateEventsField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notificationEmailAddress {
            get {
                return this.notificationEmailAddressField;
            }
            set {
                this.notificationEmailAddressField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object secretKey {
            get {
                return this.secretKeyField;
            }
            set {
                this.secretKeyField = value;
            }
        }
        public object sendThresholdExceededNotification {
            get {
                return this.sendThresholdExceededNotificationField;
            }
            set {
                this.sendThresholdExceededNotificationField = value;
            }
        }
        public object webhookGUID {
            get {
                return this.webhookGUIDField;
            }
            set {
                this.webhookGUIDField = value;
            }
        }
        public object webhookUrl {
            get {
                return this.webhookUrlField;
            }
            set {
                this.webhookUrlField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemWebhookUdfField {

        private object idField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object udfFieldIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object udfFieldID {
            get {
                return this.udfFieldIDField;
            }
            set {
                this.udfFieldIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactBillingProductAssociation {

        private object idField;
        private object billingProductIDField;
        private object contactIDField;
        private object effectiveDateField;
        private object expirationDateField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingProductID {
            get {
                return this.billingProductIDField;
            }
            set {
                this.billingProductIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object expirationDate {
            get {
                return this.expirationDateField;
            }
            set {
                this.expirationDateField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactGroupContact {

        private object idField;
        private object contactIdField;
        private object contactGroupIdField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contactId {
            get {
                return this.contactIdField;
            }
            set {
                this.contactIdField = value;
            }
        }
        public object contactGroupId {
            get {
                return this.contactGroupIdField;
            }
            set {
                this.contactGroupIdField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactGroup {

        private object idField;
        private object nameField;
        private object isActiveField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactWebhookExcludedResource {

        private object idField;
        private object resourceIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactWebhookField {

        private object idField;
        private object fieldIDField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object fieldID {
            get {
                return this.fieldIDField;
            }
            set {
                this.fieldIDField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactWebhook {

        private object idField;
        private object deactivationUrlField;
        private object isActiveField;
        private object isReadyField;
        private object isSubscribedToCreateEventsField;
        private object isSubscribedToDeleteEventsField;
        private object isSubscribedToUpdateEventsField;
        private object nameField;
        private object notificationEmailAddressField;
        private object ownerResourceIDField;
        private object secretKeyField;
        private object sendThresholdExceededNotificationField;
        private object webhookGUIDField;
        private object webhookUrlField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object deactivationUrl {
            get {
                return this.deactivationUrlField;
            }
            set {
                this.deactivationUrlField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isReady {
            get {
                return this.isReadyField;
            }
            set {
                this.isReadyField = value;
            }
        }
        public object isSubscribedToCreateEvents {
            get {
                return this.isSubscribedToCreateEventsField;
            }
            set {
                this.isSubscribedToCreateEventsField = value;
            }
        }
        public object isSubscribedToDeleteEvents {
            get {
                return this.isSubscribedToDeleteEventsField;
            }
            set {
                this.isSubscribedToDeleteEventsField = value;
            }
        }
        public object isSubscribedToUpdateEvents {
            get {
                return this.isSubscribedToUpdateEventsField;
            }
            set {
                this.isSubscribedToUpdateEventsField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notificationEmailAddress {
            get {
                return this.notificationEmailAddressField;
            }
            set {
                this.notificationEmailAddressField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object secretKey {
            get {
                return this.secretKeyField;
            }
            set {
                this.secretKeyField = value;
            }
        }
        public object sendThresholdExceededNotification {
            get {
                return this.sendThresholdExceededNotificationField;
            }
            set {
                this.sendThresholdExceededNotificationField = value;
            }
        }
        public object webhookGUID {
            get {
                return this.webhookGUIDField;
            }
            set {
                this.webhookGUIDField = value;
            }
        }
        public object webhookUrl {
            get {
                return this.webhookUrlField;
            }
            set {
                this.webhookUrlField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContactWebhookUdfField {

        private object idField;
        private object isDisplayAlwaysFieldField;
        private object isSubscribedFieldField;
        private object udfFieldIDField;
        private object webhookIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isDisplayAlwaysField {
            get {
                return this.isDisplayAlwaysFieldField;
            }
            set {
                this.isDisplayAlwaysFieldField = value;
            }
        }
        public object isSubscribedField {
            get {
                return this.isSubscribedFieldField;
            }
            set {
                this.isSubscribedFieldField = value;
            }
        }
        public object udfFieldID {
            get {
                return this.udfFieldIDField;
            }
            set {
                this.udfFieldIDField = value;
            }
        }
        public object webhookID {
            get {
                return this.webhookIDField;
            }
            set {
                this.webhookIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractBillingRule {

        private object idField;
        private object contractIDField;
        private object createChargesAsBillableField;
        private object dailyProratedCostField;
        private object dailyProratedPriceField;
        private object determineUnitsField;
        private object endDateField;
        private object executionMethodField;
        private object includeItemsInChargeDescriptionField;
        private object invoiceDescriptionField;
        private object isActiveField;
        private object isDailyProrationEnabledField;
        private object maximumUnitsField;
        private object minimumUnitsField;
        private object productIDField;
        private object startDateField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object createChargesAsBillable {
            get {
                return this.createChargesAsBillableField;
            }
            set {
                this.createChargesAsBillableField = value;
            }
        }
        public object dailyProratedCost {
            get {
                return this.dailyProratedCostField;
            }
            set {
                this.dailyProratedCostField = value;
            }
        }
        public object dailyProratedPrice {
            get {
                return this.dailyProratedPriceField;
            }
            set {
                this.dailyProratedPriceField = value;
            }
        }
        public object determineUnits {
            get {
                return this.determineUnitsField;
            }
            set {
                this.determineUnitsField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object executionMethod {
            get {
                return this.executionMethodField;
            }
            set {
                this.executionMethodField = value;
            }
        }
        public object includeItemsInChargeDescription {
            get {
                return this.includeItemsInChargeDescriptionField;
            }
            set {
                this.includeItemsInChargeDescriptionField = value;
            }
        }
        public object invoiceDescription {
            get {
                return this.invoiceDescriptionField;
            }
            set {
                this.invoiceDescriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDailyProrationEnabled {
            get {
                return this.isDailyProrationEnabledField;
            }
            set {
                this.isDailyProrationEnabledField = value;
            }
        }
        public object maximumUnits {
            get {
                return this.maximumUnitsField;
            }
            set {
                this.maximumUnitsField = value;
            }
        }
        public object minimumUnits {
            get {
                return this.minimumUnitsField;
            }
            set {
                this.minimumUnitsField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractBlockHourFactor {

        private object idField;
        private object blockHourMultiplierField;
        private object contractIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object blockHourMultiplier {
            get {
                return this.blockHourMultiplierField;
            }
            set {
                this.blockHourMultiplierField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractBlock {

        private object idField;
        private object contractIDField;
        private object datePurchasedField;
        private object endDateField;
        private object hourlyRateField;
        private object hoursField;
        private object hoursApprovedField;
        private object invoiceNumberField;
        private object isPaidField;
        private object paymentNumberField;
        private object paymentTypeField;
        private object startDateField;
        private object statusField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object hourlyRate {
            get {
                return this.hourlyRateField;
            }
            set {
                this.hourlyRateField = value;
            }
        }
        public object hours {
            get {
                return this.hoursField;
            }
            set {
                this.hoursField = value;
            }
        }
        public object hoursApproved {
            get {
                return this.hoursApprovedField;
            }
            set {
                this.hoursApprovedField = value;
            }
        }
        public object invoiceNumber {
            get {
                return this.invoiceNumberField;
            }
            set {
                this.invoiceNumberField = value;
            }
        }
        public object isPaid {
            get {
                return this.isPaidField;
            }
            set {
                this.isPaidField = value;
            }
        }
        public object paymentNumber {
            get {
                return this.paymentNumberField;
            }
            set {
                this.paymentNumberField = value;
            }
        }
        public object paymentType {
            get {
                return this.paymentTypeField;
            }
            set {
                this.paymentTypeField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractCharge {

        private object idField;
        private object billableAmountField;
        private object billingCodeIDField;
        private object chargeTypeField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object datePurchasedField;
        private object descriptionField;
        private object extendedCostField;
        private object internalCurrencyBillableAmountField;
        private object internalCurrencyUnitPriceField;
        private object internalPurchaseOrderNumberField;
        private object isBillableToCompanyField;
        private object isBilledField;
        private object nameField;
        private object notesField;
        private object organizationalLevelAssociationIDField;
        private object productIDField;
        private object purchaseOrderNumberField;
        private object statusField;
        private object statusLastModifiedByField;
        private object statusLastModifiedDateField;
        private object unitCostField;
        private object unitPriceField;
        private object unitQuantityField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billableAmount {
            get {
                return this.billableAmountField;
            }
            set {
                this.billableAmountField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object chargeType {
            get {
                return this.chargeTypeField;
            }
            set {
                this.chargeTypeField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object extendedCost {
            get {
                return this.extendedCostField;
            }
            set {
                this.extendedCostField = value;
            }
        }
        public object internalCurrencyBillableAmount {
            get {
                return this.internalCurrencyBillableAmountField;
            }
            set {
                this.internalCurrencyBillableAmountField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalPurchaseOrderNumber {
            get {
                return this.internalPurchaseOrderNumberField;
            }
            set {
                this.internalPurchaseOrderNumberField = value;
            }
        }
        public object isBillableToCompany {
            get {
                return this.isBillableToCompanyField;
            }
            set {
                this.isBillableToCompanyField = value;
            }
        }
        public object isBilled {
            get {
                return this.isBilledField;
            }
            set {
                this.isBilledField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object statusLastModifiedBy {
            get {
                return this.statusLastModifiedByField;
            }
            set {
                this.statusLastModifiedByField = value;
            }
        }
        public object statusLastModifiedDate {
            get {
                return this.statusLastModifiedDateField;
            }
            set {
                this.statusLastModifiedDateField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object unitQuantity {
            get {
                return this.unitQuantityField;
            }
            set {
                this.unitQuantityField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractExclusionBillingCode {

        private object idField;
        private object billingCodeIDField;
        private object contractIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractExclusionRole {

        private object idField;
        private object contractIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractExclusionSetExcludedRole {

        private object idField;
        private object contractExclusionSetIDField;
        private object excludedRoleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractExclusionSetID {
            get {
                return this.contractExclusionSetIDField;
            }
            set {
                this.contractExclusionSetIDField = value;
            }
        }
        public object excludedRoleID {
            get {
                return this.excludedRoleIDField;
            }
            set {
                this.excludedRoleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractExclusionSetExcludedWorkType {

        private object idField;
        private object contractExclusionSetIDField;
        private object excludedWorkTypeIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractExclusionSetID {
            get {
                return this.contractExclusionSetIDField;
            }
            set {
                this.contractExclusionSetIDField = value;
            }
        }
        public object excludedWorkTypeID {
            get {
                return this.excludedWorkTypeIDField;
            }
            set {
                this.excludedWorkTypeIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractExclusionSet {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractMilestone {

        private object idField;
        private object amountField;
        private object billingCodeIDField;
        private object contractIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object dateDueField;
        private object descriptionField;
        private object internalCurrencyAmountField;
        private object isInitialPaymentField;
        private object organizationalLevelAssociationIDField;
        private object statusField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object amount {
            get {
                return this.amountField;
            }
            set {
                this.amountField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object dateDue {
            get {
                return this.dateDueField;
            }
            set {
                this.dateDueField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object internalCurrencyAmount {
            get {
                return this.internalCurrencyAmountField;
            }
            set {
                this.internalCurrencyAmountField = value;
            }
        }
        public object isInitialPayment {
            get {
                return this.isInitialPaymentField;
            }
            set {
                this.isInitialPaymentField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractNoteAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object contractIDField;
        private object contractNoteIDField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractNoteID {
            get {
                return this.contractNoteIDField;
            }
            set {
                this.contractNoteIDField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ContractNote {

        private object idField;
        private object contractIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastActivityDateField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractRate {

        private object idField;
        private object contractHourlyRateField;
        private object contractIDField;
        private object internalCurrencyContractHourlyRateField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractHourlyRate {
            get {
                return this.contractHourlyRateField;
            }
            set {
                this.contractHourlyRateField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object internalCurrencyContractHourlyRate {
            get {
                return this.internalCurrencyContractHourlyRateField;
            }
            set {
                this.internalCurrencyContractHourlyRateField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractRetainer {

        private object idField;
        private object amountField;
        private object amountApprovedField;
        private object contractIDField;
        private object datePurchasedField;
        private object endDateField;
        private object internalCurrencyAmountField;
        private object internalCurrencyAmountApprovedField;
        private object invoiceNumberField;
        private object isPaidField;
        private object paymentIDField;
        private object paymentNumberField;
        private object startDateField;
        private object statusField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object amount {
            get {
                return this.amountField;
            }
            set {
                this.amountField = value;
            }
        }
        public object amountApproved {
            get {
                return this.amountApprovedField;
            }
            set {
                this.amountApprovedField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object internalCurrencyAmount {
            get {
                return this.internalCurrencyAmountField;
            }
            set {
                this.internalCurrencyAmountField = value;
            }
        }
        public object internalCurrencyAmountApproved {
            get {
                return this.internalCurrencyAmountApprovedField;
            }
            set {
                this.internalCurrencyAmountApprovedField = value;
            }
        }
        public object invoiceNumber {
            get {
                return this.invoiceNumberField;
            }
            set {
                this.invoiceNumberField = value;
            }
        }
        public object isPaid {
            get {
                return this.isPaidField;
            }
            set {
                this.isPaidField = value;
            }
        }
        public object paymentID {
            get {
                return this.paymentIDField;
            }
            set {
                this.paymentIDField = value;
            }
        }
        public object paymentNumber {
            get {
                return this.paymentNumberField;
            }
            set {
                this.paymentNumberField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractRoleCost {

        private object idField;
        private object contractIDField;
        private object rateField;
        private object resourceIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object rate {
            get {
                return this.rateField;
            }
            set {
                this.rateField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Contract {

        private object idField;
        private object billingPreferenceField;
        private object billToCompanyContactIDField;
        private object billToCompanyIDField;
        private object companyIDField;
        private object contactIDField;
        private object contactNameField;
        private object contractCategoryField;
        private object contractExclusionSetIDField;
        private object contractNameField;
        private object contractNumberField;
        private object contractPeriodTypeField;
        private object contractTypeField;
        private object descriptionField;
        private object endDateField;
        private object estimatedCostField;
        private object estimatedHoursField;
        private object estimatedRevenueField;
        private object exclusionContractIDField;
        private object internalCurrencyOverageBillingRateField;
        private object internalCurrencySetupFeeField;
        private object isCompliantField;
        private object isDefaultContractField;
        private object opportunityIDField;
        private object organizationalLevelAssociationIDField;
        private object overageBillingRateField;
        private object purchaseOrderNumberField;
        private object renewedContractIDField;
        private object serviceLevelAgreementIDField;
        private object setupFeeField;
        private object setupFeeBillingCodeIDField;
        private object startDateField;
        private object statusField;
        private object timeReportingRequiresStartAndStopTimesField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingPreference {
            get {
                return this.billingPreferenceField;
            }
            set {
                this.billingPreferenceField = value;
            }
        }
        public object billToCompanyContactID {
            get {
                return this.billToCompanyContactIDField;
            }
            set {
                this.billToCompanyContactIDField = value;
            }
        }
        public object billToCompanyID {
            get {
                return this.billToCompanyIDField;
            }
            set {
                this.billToCompanyIDField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contactName {
            get {
                return this.contactNameField;
            }
            set {
                this.contactNameField = value;
            }
        }
        public object contractCategory {
            get {
                return this.contractCategoryField;
            }
            set {
                this.contractCategoryField = value;
            }
        }
        public object contractExclusionSetID {
            get {
                return this.contractExclusionSetIDField;
            }
            set {
                this.contractExclusionSetIDField = value;
            }
        }
        public object contractName {
            get {
                return this.contractNameField;
            }
            set {
                this.contractNameField = value;
            }
        }
        public object contractNumber {
            get {
                return this.contractNumberField;
            }
            set {
                this.contractNumberField = value;
            }
        }
        public object contractPeriodType {
            get {
                return this.contractPeriodTypeField;
            }
            set {
                this.contractPeriodTypeField = value;
            }
        }
        public object contractType {
            get {
                return this.contractTypeField;
            }
            set {
                this.contractTypeField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object estimatedCost {
            get {
                return this.estimatedCostField;
            }
            set {
                this.estimatedCostField = value;
            }
        }
        public object estimatedHours {
            get {
                return this.estimatedHoursField;
            }
            set {
                this.estimatedHoursField = value;
            }
        }
        public object estimatedRevenue {
            get {
                return this.estimatedRevenueField;
            }
            set {
                this.estimatedRevenueField = value;
            }
        }
        public object exclusionContractID {
            get {
                return this.exclusionContractIDField;
            }
            set {
                this.exclusionContractIDField = value;
            }
        }
        public object internalCurrencyOverageBillingRate {
            get {
                return this.internalCurrencyOverageBillingRateField;
            }
            set {
                this.internalCurrencyOverageBillingRateField = value;
            }
        }
        public object internalCurrencySetupFee {
            get {
                return this.internalCurrencySetupFeeField;
            }
            set {
                this.internalCurrencySetupFeeField = value;
            }
        }
        public object isCompliant {
            get {
                return this.isCompliantField;
            }
            set {
                this.isCompliantField = value;
            }
        }
        public object isDefaultContract {
            get {
                return this.isDefaultContractField;
            }
            set {
                this.isDefaultContractField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object overageBillingRate {
            get {
                return this.overageBillingRateField;
            }
            set {
                this.overageBillingRateField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object renewedContractID {
            get {
                return this.renewedContractIDField;
            }
            set {
                this.renewedContractIDField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object setupFee {
            get {
                return this.setupFeeField;
            }
            set {
                this.setupFeeField = value;
            }
        }
        public object setupFeeBillingCodeID {
            get {
                return this.setupFeeBillingCodeIDField;
            }
            set {
                this.setupFeeBillingCodeIDField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object timeReportingRequiresStartAndStopTimes {
            get {
                return this.timeReportingRequiresStartAndStopTimesField;
            }
            set {
                this.timeReportingRequiresStartAndStopTimesField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractServiceAdjustment {

        private object idField;
        private object adjustedUnitCostField;
        private object adjustedUnitPriceField;
        private object allowRepeatServiceField;
        private object contractIDField;
        private object contractServiceIDField;
        private object effectiveDateField;
        private object quoteItemIDField;
        private object serviceIDField;
        private object unitChangeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object adjustedUnitCost {
            get {
                return this.adjustedUnitCostField;
            }
            set {
                this.adjustedUnitCostField = value;
            }
        }
        public object adjustedUnitPrice {
            get {
                return this.adjustedUnitPriceField;
            }
            set {
                this.adjustedUnitPriceField = value;
            }
        }
        public object allowRepeatService {
            get {
                return this.allowRepeatServiceField;
            }
            set {
                this.allowRepeatServiceField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object quoteItemID {
            get {
                return this.quoteItemIDField;
            }
            set {
                this.quoteItemIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object unitChange {
            get {
                return this.unitChangeField;
            }
            set {
                this.unitChangeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractServiceBundleAdjustment {

        private object idField;
        private object adjustedUnitPriceField;
        private object allowRepeatServiceBundleField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object effectiveDateField;
        private object quoteItemIDField;
        private object serviceBundleIDField;
        private object unitChangeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object adjustedUnitPrice {
            get {
                return this.adjustedUnitPriceField;
            }
            set {
                this.adjustedUnitPriceField = value;
            }
        }
        public object allowRepeatServiceBundle {
            get {
                return this.allowRepeatServiceBundleField;
            }
            set {
                this.allowRepeatServiceBundleField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object quoteItemID {
            get {
                return this.quoteItemIDField;
            }
            set {
                this.quoteItemIDField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object unitChange {
            get {
                return this.unitChangeField;
            }
            set {
                this.unitChangeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractServiceBundle {

        private object idField;
        private object adjustedPriceField;
        private object contractIDField;
        private object internalCurrencyAdjustedPriceField;
        private object internalCurrencyUnitPriceField;
        private object internalDescriptionField;
        private object invoiceDescriptionField;
        private object quoteItemIDField;
        private object serviceBundleIDField;
        private object unitPriceField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object adjustedPrice {
            get {
                return this.adjustedPriceField;
            }
            set {
                this.adjustedPriceField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object internalCurrencyAdjustedPrice {
            get {
                return this.internalCurrencyAdjustedPriceField;
            }
            set {
                this.internalCurrencyAdjustedPriceField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalDescription {
            get {
                return this.internalDescriptionField;
            }
            set {
                this.internalDescriptionField = value;
            }
        }
        public object invoiceDescription {
            get {
                return this.invoiceDescriptionField;
            }
            set {
                this.invoiceDescriptionField = value;
            }
        }
        public object quoteItemID {
            get {
                return this.quoteItemIDField;
            }
            set {
                this.quoteItemIDField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractService {

        private object idField;
        private object contractIDField;
        private object internalCurrencyAdjustedPriceField;
        private object internalCurrencyUnitPriceField;
        private object internalDescriptionField;
        private object invoiceDescriptionField;
        private object quoteItemIDField;
        private object serviceIDField;
        private object unitCostField;
        private object unitPriceField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object internalCurrencyAdjustedPrice {
            get {
                return this.internalCurrencyAdjustedPriceField;
            }
            set {
                this.internalCurrencyAdjustedPriceField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalDescription {
            get {
                return this.internalDescriptionField;
            }
            set {
                this.internalDescriptionField = value;
            }
        }
        public object invoiceDescription {
            get {
                return this.invoiceDescriptionField;
            }
            set {
                this.invoiceDescriptionField = value;
            }
        }
        public object quoteItemID {
            get {
                return this.quoteItemIDField;
            }
            set {
                this.quoteItemIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractTicketPurchase {

        private object idField;
        private object contractIDField;
        private object datePurchasedField;
        private object endDateField;
        private object invoiceNumberField;
        private object isPaidField;
        private object paymentNumberField;
        private object paymentTypeField;
        private object perTicketRateField;
        private object startDateField;
        private object statusField;
        private object ticketsPurchasedField;
        private object ticketsUsedField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object invoiceNumber {
            get {
                return this.invoiceNumberField;
            }
            set {
                this.invoiceNumberField = value;
            }
        }
        public object isPaid {
            get {
                return this.isPaidField;
            }
            set {
                this.isPaidField = value;
            }
        }
        public object paymentNumber {
            get {
                return this.paymentNumberField;
            }
            set {
                this.paymentNumberField = value;
            }
        }
        public object paymentType {
            get {
                return this.paymentTypeField;
            }
            set {
                this.paymentTypeField = value;
            }
        }
        public object perTicketRate {
            get {
                return this.perTicketRateField;
            }
            set {
                this.perTicketRateField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object ticketsPurchased {
            get {
                return this.ticketsPurchasedField;
            }
            set {
                this.ticketsPurchasedField = value;
            }
        }
        public object ticketsUsed {
            get {
                return this.ticketsUsedField;
            }
            set {
                this.ticketsUsedField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Country {

        private object idField;
        private object addressFormatIDField;
        private object countryCodeField;
        private object displayNameField;
        private object invoiceTemplateIDField;
        private object isActiveField;
        private object isDefaultCountryField;
        private object nameField;
        private object purchaseOrderTemplateIDField;
        private object quoteTemplateIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object addressFormatID {
            get {
                return this.addressFormatIDField;
            }
            set {
                this.addressFormatIDField = value;
            }
        }
        public object countryCode {
            get {
                return this.countryCodeField;
            }
            set {
                this.countryCodeField = value;
            }
        }
        public object displayName {
            get {
                return this.displayNameField;
            }
            set {
                this.displayNameField = value;
            }
        }
        public object invoiceTemplateID {
            get {
                return this.invoiceTemplateIDField;
            }
            set {
                this.invoiceTemplateIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDefaultCountry {
            get {
                return this.isDefaultCountryField;
            }
            set {
                this.isDefaultCountryField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object purchaseOrderTemplateID {
            get {
                return this.purchaseOrderTemplateIDField;
            }
            set {
                this.purchaseOrderTemplateIDField = value;
            }
        }
        public object quoteTemplateID {
            get {
                return this.quoteTemplateIDField;
            }
            set {
                this.quoteTemplateIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Currency {

        private object idField;
        private object currencyNegativeFormatField;
        private object currencyPositiveFormatField;
        private object descriptionField;
        private object displaySymbolField;
        private object exchangeRateField;
        private object isActiveField;
        private object isInternalCurrencyField;
        private object lastModifiedDateTimeField;
        private object nameField;
        private object updateResourceIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyNegativeFormat {
            get {
                return this.currencyNegativeFormatField;
            }
            set {
                this.currencyNegativeFormatField = value;
            }
        }
        public object currencyPositiveFormat {
            get {
                return this.currencyPositiveFormatField;
            }
            set {
                this.currencyPositiveFormatField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object displaySymbol {
            get {
                return this.displaySymbolField;
            }
            set {
                this.displaySymbolField = value;
            }
        }
        public object exchangeRate {
            get {
                return this.exchangeRateField;
            }
            set {
                this.exchangeRateField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isInternalCurrency {
            get {
                return this.isInternalCurrencyField;
            }
            set {
                this.isInternalCurrencyField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object updateResourceId {
            get {
                return this.updateResourceIdField;
            }
            set {
                this.updateResourceIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Department {

        private object idField;
        private object descriptionField;
        private object nameField;
        private object numberField;
        private object primaryLocationIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object number {
            get {
                return this.numberField;
            }
            set {
                this.numberField = value;
            }
        }
        public object primaryLocationID {
            get {
                return this.primaryLocationIDField;
            }
            set {
                this.primaryLocationIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object documentIDField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object titleField;
        private object dataField;
        private object publishField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class DocumentCategory {

        private object idField;
        private object descriptionField;
        private object nameField;
        private object parentCategoryIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object parentCategoryID {
            get {
                return this.parentCategoryIDField;
            }
            set {
                this.parentCategoryIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentChecklistItem {

        private object idField;
        private object documentIDField;
        private object isImportantField;
        private object itemNameField;
        private object positionField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object isImportant {
            get {
                return this.isImportantField;
            }
            set {
                this.isImportantField = value;
            }
        }
        public object itemName {
            get {
                return this.itemNameField;
            }
            set {
                this.itemNameField = value;
            }
        }
        public object position {
            get {
                return this.positionField;
            }
            set {
                this.positionField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentChecklistLibrary {

        private object idField;
        private object checklistLibraryIDField;
        private object documentIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object checklistLibraryID {
            get {
                return this.checklistLibraryIDField;
            }
            set {
                this.checklistLibraryIDField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentConfigurationItemAssociation {

        private object idField;
        private object configurationItemIDField;
        private object documentIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentConfigurationItemCategoryAssociation {

        private object idField;
        private object documentIDField;
        private object installedProductCategoryIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object installedProductCategoryID {
            get {
                return this.installedProductCategoryIDField;
            }
            set {
                this.installedProductCategoryIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentNote {

        private object idField;
        private object createdByResourceIDField;
        private object createdDateTimeField;
        private object descriptionField;
        private object documentIDField;
        private object lastModifiedByResourceIDField;
        private object lastModifiedDateTimeField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object createdDateTime {
            get {
                return this.createdDateTimeField;
            }
            set {
                this.createdDateTimeField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object lastModifiedByResourceID {
            get {
                return this.lastModifiedByResourceIDField;
            }
            set {
                this.lastModifiedByResourceIDField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentPlainTextContent {

        private object idField;
        private object contentDataField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contentData {
            get {
                return this.contentDataField;
            }
            set {
                this.contentDataField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Document {

        private object idField;
        private object companyIDField;
        private object createdByResourceIDField;
        private object createdDateTimeField;
        private object documentCategoryIDField;
        private object errorCodesField;
        private object isActiveField;
        private object keywordsField;
        private object lastModifiedByResourceIDField;
        private object lastModifiedDateTimeField;
        private object publishField;
        private object referenceLinkField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object createdDateTime {
            get {
                return this.createdDateTimeField;
            }
            set {
                this.createdDateTimeField = value;
            }
        }
        public object documentCategoryID {
            get {
                return this.documentCategoryIDField;
            }
            set {
                this.documentCategoryIDField = value;
            }
        }
        public object errorCodes {
            get {
                return this.errorCodesField;
            }
            set {
                this.errorCodesField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object keywords {
            get {
                return this.keywordsField;
            }
            set {
                this.keywordsField = value;
            }
        }
        public object lastModifiedByResourceID {
            get {
                return this.lastModifiedByResourceIDField;
            }
            set {
                this.lastModifiedByResourceIDField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object referenceLink {
            get {
                return this.referenceLinkField;
            }
            set {
                this.referenceLinkField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentTagAssociation {

        private object idField;
        private object createDateTimeField;
        private object createdByResourceIDField;
        private object documentIDField;
        private object tagIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object tagID {
            get {
                return this.tagIDField;
            }
            set {
                this.tagIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentTicketAssociation {

        private object idField;
        private object documentIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentToArticleAssociation {

        private object idField;
        private object associatedArticleIDField;
        private object documentIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object associatedArticleID {
            get {
                return this.associatedArticleIDField;
            }
            set {
                this.associatedArticleIDField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DocumentToDocumentAssociation {

        private object idField;
        private object associatedDocumentIDField;
        private object documentIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object associatedDocumentID {
            get {
                return this.associatedDocumentIDField;
            }
            set {
                this.associatedDocumentIDField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DomainRegistrar {

        private object idField;
        private object nameField;
        private object urlField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object url {
            get {
                return this.urlField;
            }
            set {
                this.urlField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ExpenseItem {

        private object idField;
        private object companyIDField;
        private object descriptionField;
        private object destinationField;
        private object entertainmentLocationField;
        private object expenseCategoryField;
        private object expenseCurrencyExpenseAmountField;
        private object expenseCurrencyIDField;
        private object expenseDateField;
        private object expenseReportIDField;
        private object glCodeField;
        private object haveReceiptField;
        private object internalCurrencyExpenseAmountField;
        private object internalCurrencyReimbursementAmountField;
        private object isBillableToCompanyField;
        private object isReimbursableField;
        private object isRejectedField;
        private object milesField;
        private object odometerEndField;
        private object odometerStartField;
        private object originField;
        private object paymentTypeField;
        private object projectIDField;
        private object purchaseOrderNumberField;
        private object reimbursementCurrencyReimbursementAmountField;
        private object taskIDField;
        private object ticketIDField;
        private object workTypeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object destination {
            get {
                return this.destinationField;
            }
            set {
                this.destinationField = value;
            }
        }
        public object entertainmentLocation {
            get {
                return this.entertainmentLocationField;
            }
            set {
                this.entertainmentLocationField = value;
            }
        }
        public object expenseCategory {
            get {
                return this.expenseCategoryField;
            }
            set {
                this.expenseCategoryField = value;
            }
        }
        public object expenseCurrencyExpenseAmount {
            get {
                return this.expenseCurrencyExpenseAmountField;
            }
            set {
                this.expenseCurrencyExpenseAmountField = value;
            }
        }
        public object expenseCurrencyID {
            get {
                return this.expenseCurrencyIDField;
            }
            set {
                this.expenseCurrencyIDField = value;
            }
        }
        public object expenseDate {
            get {
                return this.expenseDateField;
            }
            set {
                this.expenseDateField = value;
            }
        }
        public object expenseReportID {
            get {
                return this.expenseReportIDField;
            }
            set {
                this.expenseReportIDField = value;
            }
        }
        public object glCode {
            get {
                return this.glCodeField;
            }
            set {
                this.glCodeField = value;
            }
        }
        public object haveReceipt {
            get {
                return this.haveReceiptField;
            }
            set {
                this.haveReceiptField = value;
            }
        }
        public object internalCurrencyExpenseAmount {
            get {
                return this.internalCurrencyExpenseAmountField;
            }
            set {
                this.internalCurrencyExpenseAmountField = value;
            }
        }
        public object internalCurrencyReimbursementAmount {
            get {
                return this.internalCurrencyReimbursementAmountField;
            }
            set {
                this.internalCurrencyReimbursementAmountField = value;
            }
        }
        public object isBillableToCompany {
            get {
                return this.isBillableToCompanyField;
            }
            set {
                this.isBillableToCompanyField = value;
            }
        }
        public object isReimbursable {
            get {
                return this.isReimbursableField;
            }
            set {
                this.isReimbursableField = value;
            }
        }
        public object isRejected {
            get {
                return this.isRejectedField;
            }
            set {
                this.isRejectedField = value;
            }
        }
        public object miles {
            get {
                return this.milesField;
            }
            set {
                this.milesField = value;
            }
        }
        public object odometerEnd {
            get {
                return this.odometerEndField;
            }
            set {
                this.odometerEndField = value;
            }
        }
        public object odometerStart {
            get {
                return this.odometerStartField;
            }
            set {
                this.odometerStartField = value;
            }
        }
        public object origin {
            get {
                return this.originField;
            }
            set {
                this.originField = value;
            }
        }
        public object paymentType {
            get {
                return this.paymentTypeField;
            }
            set {
                this.paymentTypeField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object reimbursementCurrencyReimbursementAmount {
            get {
                return this.reimbursementCurrencyReimbursementAmountField;
            }
            set {
                this.reimbursementCurrencyReimbursementAmountField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object workType {
            get {
                return this.workTypeField;
            }
            set {
                this.workTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ExpenseReportAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object expenseReportIDField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object expenseReportID {
            get {
                return this.expenseReportIDField;
            }
            set {
                this.expenseReportIDField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ExpenseReport {

        private object idField;
        private object amountDueField;
        private object approvedDateField;
        private object approverIDField;
        private object departmentNumberField;
        private object internalCurrencyCashAdvanceAmountField;
        private object internalCurrencyExpenseTotalField;
        private object nameField;
        private object organizationalLevelAssociationIDField;
        private object quickBooksReferenceNumberField;
        private object reimbursementCurrencyAmountDueField;
        private object reimbursementCurrencyCashAdvanceAmountField;
        private object reimbursementCurrencyIDField;
        private object rejectionReasonField;
        private object statusField;
        private object submitField;
        private object submitDateField;
        private object submitterIDField;
        private object weekEndingField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object amountDue {
            get {
                return this.amountDueField;
            }
            set {
                this.amountDueField = value;
            }
        }
        public object approvedDate {
            get {
                return this.approvedDateField;
            }
            set {
                this.approvedDateField = value;
            }
        }
        public object approverID {
            get {
                return this.approverIDField;
            }
            set {
                this.approverIDField = value;
            }
        }
        public object departmentNumber {
            get {
                return this.departmentNumberField;
            }
            set {
                this.departmentNumberField = value;
            }
        }
        public object internalCurrencyCashAdvanceAmount {
            get {
                return this.internalCurrencyCashAdvanceAmountField;
            }
            set {
                this.internalCurrencyCashAdvanceAmountField = value;
            }
        }
        public object internalCurrencyExpenseTotal {
            get {
                return this.internalCurrencyExpenseTotalField;
            }
            set {
                this.internalCurrencyExpenseTotalField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object quickBooksReferenceNumber {
            get {
                return this.quickBooksReferenceNumberField;
            }
            set {
                this.quickBooksReferenceNumberField = value;
            }
        }
        public object reimbursementCurrencyAmountDue {
            get {
                return this.reimbursementCurrencyAmountDueField;
            }
            set {
                this.reimbursementCurrencyAmountDueField = value;
            }
        }
        public object reimbursementCurrencyCashAdvanceAmount {
            get {
                return this.reimbursementCurrencyCashAdvanceAmountField;
            }
            set {
                this.reimbursementCurrencyCashAdvanceAmountField = value;
            }
        }
        public object reimbursementCurrencyID {
            get {
                return this.reimbursementCurrencyIDField;
            }
            set {
                this.reimbursementCurrencyIDField = value;
            }
        }
        public object rejectionReason {
            get {
                return this.rejectionReasonField;
            }
            set {
                this.rejectionReasonField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object submit {
            get {
                return this.submitField;
            }
            set {
                this.submitField = value;
            }
        }
        public object submitDate {
            get {
                return this.submitDateField;
            }
            set {
                this.submitDateField = value;
            }
        }
        public object submitterID {
            get {
                return this.submitterIDField;
            }
            set {
                this.submitterIDField = value;
            }
        }
        public object weekEnding {
            get {
                return this.weekEndingField;
            }
            set {
                this.weekEndingField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Holiday {

        private object idField;
        private object holidayDateField;
        private object holidayNameField;
        private object holidaySetIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object holidayDate {
            get {
                return this.holidayDateField;
            }
            set {
                this.holidayDateField = value;
            }
        }
        public object holidayName {
            get {
                return this.holidayNameField;
            }
            set {
                this.holidayNameField = value;
            }
        }
        public object holidaySetID {
            get {
                return this.holidaySetIDField;
            }
            set {
                this.holidaySetIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class HolidaySet {

        private object idField;
        private object holidaySetDescriptionField;
        private object holidaySetNameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object holidaySetDescription {
            get {
                return this.holidaySetDescriptionField;
            }
            set {
                this.holidaySetDescriptionField = value;
            }
        }
        public object holidaySetName {
            get {
                return this.holidaySetNameField;
            }
            set {
                this.holidaySetNameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class IntegrationVendorInsight {

        private object idField;
        private object createDateTimeField;
        private object descriptionField;
        private object heightField;
        private object insightCategoryField;
        private object insightKeyField;
        private object isActiveField;
        private object lastModifiedDateTimeField;
        private object referenceUrlField;
        private object secretField;
        private object titleField;
        private object vendorSuppliedIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object height {
            get {
                return this.heightField;
            }
            set {
                this.heightField = value;
            }
        }
        public object insightCategory {
            get {
                return this.insightCategoryField;
            }
            set {
                this.insightCategoryField = value;
            }
        }
        public object insightKey {
            get {
                return this.insightKeyField;
            }
            set {
                this.insightKeyField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object referenceUrl {
            get {
                return this.referenceUrlField;
            }
            set {
                this.referenceUrlField = value;
            }
        }
        public object secret {
            get {
                return this.secretField;
            }
            set {
                this.secretField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object vendorSuppliedID {
            get {
                return this.vendorSuppliedIDField;
            }
            set {
                this.vendorSuppliedIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class IntegrationVendorWidget {

        private object idField;
        private object createDateTimeField;
        private object descriptionField;
        private object isActiveField;
        private object lastModifiedDateTimeField;
        private object referenceUrlField;
        private object secretField;
        private object titleField;
        private object vendorSuppliedIDField;
        private object widgetKeyField;
        private object widthField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object referenceUrl {
            get {
                return this.referenceUrlField;
            }
            set {
                this.referenceUrlField = value;
            }
        }
        public object secret {
            get {
                return this.secretField;
            }
            set {
                this.secretField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object vendorSuppliedID {
            get {
                return this.vendorSuppliedIDField;
            }
            set {
                this.vendorSuppliedIDField = value;
            }
        }
        public object widgetKey {
            get {
                return this.widgetKeyField;
            }
            set {
                this.widgetKeyField = value;
            }
        }
        public object width {
            get {
                return this.widthField;
            }
            set {
                this.widthField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InternalLocationWithBusinessHours {

        private object idField;
        private object additionalAddressInfoField;
        private object address1Field;
        private object address2Field;
        private object cityField;
        private object countryIDField;
        private object dateFormatField;
        private object firstDayOfWeekField;
        private object fridayBusinessHoursEndTimeField;
        private object fridayBusinessHoursStartTimeField;
        private object fridayExtendedHoursEndTimeField;
        private object fridayExtendedHoursStartTimeField;
        private object holidayExtendedHoursEndTimeField;
        private object holidayExtendedHoursStartTimeField;
        private object holidayHoursEndTimeField;
        private object holidayHoursStartTimeField;
        private object holidayHoursTypeField;
        private object holidaySetIDField;
        private object isDefaultField;
        private object mondayBusinessHoursEndTimeField;
        private object mondayBusinessHoursStartTimeField;
        private object mondayExtendedHoursEndTimeField;
        private object mondayExtendedHoursStartTimeField;
        private object nameField;
        private object noHoursOnHolidaysField;
        private object numberFormatField;
        private object postalCodeField;
        private object saturdayBusinessHoursEndTimeField;
        private object saturdayBusinessHoursStartTimeField;
        private object saturdayExtendedHoursEndTimeField;
        private object saturdayExtendedHoursStartTimeField;
        private object stateField;
        private object sundayBusinessHoursEndTimeField;
        private object sundayBusinessHoursStartTimeField;
        private object sundayExtendedHoursEndTimeField;
        private object sundayExtendedHoursStartTimeField;
        private object thursdayBusinessHoursEndTimeField;
        private object thursdayBusinessHoursStartTimeField;
        private object thursdayExtendedHoursEndTimeField;
        private object thursdayExtendedHoursStartTimeField;
        private object timeFormatField;
        private object timeZoneIDField;
        private object tuesdayBusinessHoursEndTimeField;
        private object tuesdayBusinessHoursStartTimeField;
        private object tuesdayExtendedHoursEndTimeField;
        private object tuesdayExtendedHoursStartTimeField;
        private object wednesdayBusinessHoursEndTimeField;
        private object wednesdayBusinessHoursStartTimeField;
        private object wednesdayExtendedHoursEndTimeField;
        private object wednesdayExtendedHoursStartTimeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalAddressInfo {
            get {
                return this.additionalAddressInfoField;
            }
            set {
                this.additionalAddressInfoField = value;
            }
        }
        public object address1 {
            get {
                return this.address1Field;
            }
            set {
                this.address1Field = value;
            }
        }
        public object address2 {
            get {
                return this.address2Field;
            }
            set {
                this.address2Field = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object countryID {
            get {
                return this.countryIDField;
            }
            set {
                this.countryIDField = value;
            }
        }
        public object dateFormat {
            get {
                return this.dateFormatField;
            }
            set {
                this.dateFormatField = value;
            }
        }
        public object firstDayOfWeek {
            get {
                return this.firstDayOfWeekField;
            }
            set {
                this.firstDayOfWeekField = value;
            }
        }
        public object fridayBusinessHoursEndTime {
            get {
                return this.fridayBusinessHoursEndTimeField;
            }
            set {
                this.fridayBusinessHoursEndTimeField = value;
            }
        }
        public object fridayBusinessHoursStartTime {
            get {
                return this.fridayBusinessHoursStartTimeField;
            }
            set {
                this.fridayBusinessHoursStartTimeField = value;
            }
        }
        public object fridayExtendedHoursEndTime {
            get {
                return this.fridayExtendedHoursEndTimeField;
            }
            set {
                this.fridayExtendedHoursEndTimeField = value;
            }
        }
        public object fridayExtendedHoursStartTime {
            get {
                return this.fridayExtendedHoursStartTimeField;
            }
            set {
                this.fridayExtendedHoursStartTimeField = value;
            }
        }
        public object holidayExtendedHoursEndTime {
            get {
                return this.holidayExtendedHoursEndTimeField;
            }
            set {
                this.holidayExtendedHoursEndTimeField = value;
            }
        }
        public object holidayExtendedHoursStartTime {
            get {
                return this.holidayExtendedHoursStartTimeField;
            }
            set {
                this.holidayExtendedHoursStartTimeField = value;
            }
        }
        public object holidayHoursEndTime {
            get {
                return this.holidayHoursEndTimeField;
            }
            set {
                this.holidayHoursEndTimeField = value;
            }
        }
        public object holidayHoursStartTime {
            get {
                return this.holidayHoursStartTimeField;
            }
            set {
                this.holidayHoursStartTimeField = value;
            }
        }
        public object holidayHoursType {
            get {
                return this.holidayHoursTypeField;
            }
            set {
                this.holidayHoursTypeField = value;
            }
        }
        public object holidaySetID {
            get {
                return this.holidaySetIDField;
            }
            set {
                this.holidaySetIDField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object mondayBusinessHoursEndTime {
            get {
                return this.mondayBusinessHoursEndTimeField;
            }
            set {
                this.mondayBusinessHoursEndTimeField = value;
            }
        }
        public object mondayBusinessHoursStartTime {
            get {
                return this.mondayBusinessHoursStartTimeField;
            }
            set {
                this.mondayBusinessHoursStartTimeField = value;
            }
        }
        public object mondayExtendedHoursEndTime {
            get {
                return this.mondayExtendedHoursEndTimeField;
            }
            set {
                this.mondayExtendedHoursEndTimeField = value;
            }
        }
        public object mondayExtendedHoursStartTime {
            get {
                return this.mondayExtendedHoursStartTimeField;
            }
            set {
                this.mondayExtendedHoursStartTimeField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object noHoursOnHolidays {
            get {
                return this.noHoursOnHolidaysField;
            }
            set {
                this.noHoursOnHolidaysField = value;
            }
        }
        public object numberFormat {
            get {
                return this.numberFormatField;
            }
            set {
                this.numberFormatField = value;
            }
        }
        public object postalCode {
            get {
                return this.postalCodeField;
            }
            set {
                this.postalCodeField = value;
            }
        }
        public object saturdayBusinessHoursEndTime {
            get {
                return this.saturdayBusinessHoursEndTimeField;
            }
            set {
                this.saturdayBusinessHoursEndTimeField = value;
            }
        }
        public object saturdayBusinessHoursStartTime {
            get {
                return this.saturdayBusinessHoursStartTimeField;
            }
            set {
                this.saturdayBusinessHoursStartTimeField = value;
            }
        }
        public object saturdayExtendedHoursEndTime {
            get {
                return this.saturdayExtendedHoursEndTimeField;
            }
            set {
                this.saturdayExtendedHoursEndTimeField = value;
            }
        }
        public object saturdayExtendedHoursStartTime {
            get {
                return this.saturdayExtendedHoursStartTimeField;
            }
            set {
                this.saturdayExtendedHoursStartTimeField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object sundayBusinessHoursEndTime {
            get {
                return this.sundayBusinessHoursEndTimeField;
            }
            set {
                this.sundayBusinessHoursEndTimeField = value;
            }
        }
        public object sundayBusinessHoursStartTime {
            get {
                return this.sundayBusinessHoursStartTimeField;
            }
            set {
                this.sundayBusinessHoursStartTimeField = value;
            }
        }
        public object sundayExtendedHoursEndTime {
            get {
                return this.sundayExtendedHoursEndTimeField;
            }
            set {
                this.sundayExtendedHoursEndTimeField = value;
            }
        }
        public object sundayExtendedHoursStartTime {
            get {
                return this.sundayExtendedHoursStartTimeField;
            }
            set {
                this.sundayExtendedHoursStartTimeField = value;
            }
        }
        public object thursdayBusinessHoursEndTime {
            get {
                return this.thursdayBusinessHoursEndTimeField;
            }
            set {
                this.thursdayBusinessHoursEndTimeField = value;
            }
        }
        public object thursdayBusinessHoursStartTime {
            get {
                return this.thursdayBusinessHoursStartTimeField;
            }
            set {
                this.thursdayBusinessHoursStartTimeField = value;
            }
        }
        public object thursdayExtendedHoursEndTime {
            get {
                return this.thursdayExtendedHoursEndTimeField;
            }
            set {
                this.thursdayExtendedHoursEndTimeField = value;
            }
        }
        public object thursdayExtendedHoursStartTime {
            get {
                return this.thursdayExtendedHoursStartTimeField;
            }
            set {
                this.thursdayExtendedHoursStartTimeField = value;
            }
        }
        public object timeFormat {
            get {
                return this.timeFormatField;
            }
            set {
                this.timeFormatField = value;
            }
        }
        public object timeZoneID {
            get {
                return this.timeZoneIDField;
            }
            set {
                this.timeZoneIDField = value;
            }
        }
        public object tuesdayBusinessHoursEndTime {
            get {
                return this.tuesdayBusinessHoursEndTimeField;
            }
            set {
                this.tuesdayBusinessHoursEndTimeField = value;
            }
        }
        public object tuesdayBusinessHoursStartTime {
            get {
                return this.tuesdayBusinessHoursStartTimeField;
            }
            set {
                this.tuesdayBusinessHoursStartTimeField = value;
            }
        }
        public object tuesdayExtendedHoursEndTime {
            get {
                return this.tuesdayExtendedHoursEndTimeField;
            }
            set {
                this.tuesdayExtendedHoursEndTimeField = value;
            }
        }
        public object tuesdayExtendedHoursStartTime {
            get {
                return this.tuesdayExtendedHoursStartTimeField;
            }
            set {
                this.tuesdayExtendedHoursStartTimeField = value;
            }
        }
        public object wednesdayBusinessHoursEndTime {
            get {
                return this.wednesdayBusinessHoursEndTimeField;
            }
            set {
                this.wednesdayBusinessHoursEndTimeField = value;
            }
        }
        public object wednesdayBusinessHoursStartTime {
            get {
                return this.wednesdayBusinessHoursStartTimeField;
            }
            set {
                this.wednesdayBusinessHoursStartTimeField = value;
            }
        }
        public object wednesdayExtendedHoursEndTime {
            get {
                return this.wednesdayExtendedHoursEndTimeField;
            }
            set {
                this.wednesdayExtendedHoursEndTimeField = value;
            }
        }
        public object wednesdayExtendedHoursStartTime {
            get {
                return this.wednesdayExtendedHoursStartTimeField;
            }
            set {
                this.wednesdayExtendedHoursStartTimeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InventoryItem {

        private object idField;
        private object backOrderQuantityField;
        private object binField;
        private object impersonatorCreatorResourceIDField;
        private object inventoryLocationIDField;
        private object productIDField;
        private object quantityMaximumField;
        private object quantityMinimumField;
        private object quantityOnHandField;
        private object quantityOnOrderField;
        private object quantityPickedField;
        private object quantityReservedField;
        private object referenceNumberField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object backOrderQuantity {
            get {
                return this.backOrderQuantityField;
            }
            set {
                this.backOrderQuantityField = value;
            }
        }
        public object bin {
            get {
                return this.binField;
            }
            set {
                this.binField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object inventoryLocationID {
            get {
                return this.inventoryLocationIDField;
            }
            set {
                this.inventoryLocationIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object quantityMaximum {
            get {
                return this.quantityMaximumField;
            }
            set {
                this.quantityMaximumField = value;
            }
        }
        public object quantityMinimum {
            get {
                return this.quantityMinimumField;
            }
            set {
                this.quantityMinimumField = value;
            }
        }
        public object quantityOnHand {
            get {
                return this.quantityOnHandField;
            }
            set {
                this.quantityOnHandField = value;
            }
        }
        public object quantityOnOrder {
            get {
                return this.quantityOnOrderField;
            }
            set {
                this.quantityOnOrderField = value;
            }
        }
        public object quantityPicked {
            get {
                return this.quantityPickedField;
            }
            set {
                this.quantityPickedField = value;
            }
        }
        public object quantityReserved {
            get {
                return this.quantityReservedField;
            }
            set {
                this.quantityReservedField = value;
            }
        }
        public object referenceNumber {
            get {
                return this.referenceNumberField;
            }
            set {
                this.referenceNumberField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InventoryItemSerialNumber {

        private object idField;
        private object inventoryItemIDField;
        private object serialNumberField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object inventoryItemID {
            get {
                return this.inventoryItemIDField;
            }
            set {
                this.inventoryItemIDField = value;
            }
        }
        public object serialNumber {
            get {
                return this.serialNumberField;
            }
            set {
                this.serialNumberField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InventoryLocation {

        private object idField;
        private object impersonatorCreatorResourceIDField;
        private object isActiveField;
        private object isDefaultField;
        private object locationNameField;
        private object resourceIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object locationName {
            get {
                return this.locationNameField;
            }
            set {
                this.locationNameField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InventoryTransfer {

        private object idField;
        private object fromLocationIDField;
        private object notesField;
        private object productIDField;
        private object quantityTransferredField;
        private object serialNumberField;
        private object toLocationIDField;
        private object transferByResourceIDField;
        private object transferDateField;
        private object updateNoteField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object fromLocationID {
            get {
                return this.fromLocationIDField;
            }
            set {
                this.fromLocationIDField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object quantityTransferred {
            get {
                return this.quantityTransferredField;
            }
            set {
                this.quantityTransferredField = value;
            }
        }
        public object serialNumber {
            get {
                return this.serialNumberField;
            }
            set {
                this.serialNumberField = value;
            }
        }
        public object toLocationID {
            get {
                return this.toLocationIDField;
            }
            set {
                this.toLocationIDField = value;
            }
        }
        public object transferByResourceID {
            get {
                return this.transferByResourceIDField;
            }
            set {
                this.transferByResourceIDField = value;
            }
        }
        public object transferDate {
            get {
                return this.transferDateField;
            }
            set {
                this.transferDateField = value;
            }
        }
        public object updateNote {
            get {
                return this.updateNoteField;
            }
            set {
                this.updateNoteField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Invoice {

        private object idField;
        private object batchIDField;
        private object commentsField;
        private object companyIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object dueDateField;
        private object fromDateField;
        private object invoiceDateTimeField;
        private object invoiceEditorTemplateIDField;
        private object invoiceNumberField;
        private object invoiceTotalField;
        private object isVoidedField;
        private object orderNumberField;
        private object paidDateField;
        private object paymentTermField;
        private object taxGroupField;
        private object taxRegionNameField;
        private object toDateField;
        private object totalTaxValueField;
        private object voidedByResourceIDField;
        private object voidedDateField;
        private object webServiceDateField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object batchID {
            get {
                return this.batchIDField;
            }
            set {
                this.batchIDField = value;
            }
        }
        public object comments {
            get {
                return this.commentsField;
            }
            set {
                this.commentsField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object dueDate {
            get {
                return this.dueDateField;
            }
            set {
                this.dueDateField = value;
            }
        }
        public object fromDate {
            get {
                return this.fromDateField;
            }
            set {
                this.fromDateField = value;
            }
        }
        public object invoiceDateTime {
            get {
                return this.invoiceDateTimeField;
            }
            set {
                this.invoiceDateTimeField = value;
            }
        }
        public object invoiceEditorTemplateID {
            get {
                return this.invoiceEditorTemplateIDField;
            }
            set {
                this.invoiceEditorTemplateIDField = value;
            }
        }
        public object invoiceNumber {
            get {
                return this.invoiceNumberField;
            }
            set {
                this.invoiceNumberField = value;
            }
        }
        public object invoiceTotal {
            get {
                return this.invoiceTotalField;
            }
            set {
                this.invoiceTotalField = value;
            }
        }
        public object isVoided {
            get {
                return this.isVoidedField;
            }
            set {
                this.isVoidedField = value;
            }
        }
        public object orderNumber {
            get {
                return this.orderNumberField;
            }
            set {
                this.orderNumberField = value;
            }
        }
        public object paidDate {
            get {
                return this.paidDateField;
            }
            set {
                this.paidDateField = value;
            }
        }
        public object paymentTerm {
            get {
                return this.paymentTermField;
            }
            set {
                this.paymentTermField = value;
            }
        }
        public object taxGroup {
            get {
                return this.taxGroupField;
            }
            set {
                this.taxGroupField = value;
            }
        }
        public object taxRegionName {
            get {
                return this.taxRegionNameField;
            }
            set {
                this.taxRegionNameField = value;
            }
        }
        public object toDate {
            get {
                return this.toDateField;
            }
            set {
                this.toDateField = value;
            }
        }
        public object totalTaxValue {
            get {
                return this.totalTaxValueField;
            }
            set {
                this.totalTaxValueField = value;
            }
        }
        public object voidedByResourceID {
            get {
                return this.voidedByResourceIDField;
            }
            set {
                this.voidedByResourceIDField = value;
            }
        }
        public object voidedDate {
            get {
                return this.voidedDateField;
            }
            set {
                this.voidedDateField = value;
            }
        }
        public object webServiceDate {
            get {
                return this.webServiceDateField;
            }
            set {
                this.webServiceDateField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class KnowledgeBaseArticle {

        private object idField;
        private object createdByResourceIDField;
        private object createdDateTimeField;
        private object articleCategoryIDField;
        private object errorCodesField;
        private object isActiveField;
        private object keywordsField;
        private object lastModifiedByResourceIDField;
        private object lastModifiedDateTimeField;
        private object publishField;
        private object referenceLinkField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object createdDateTime {
            get {
                return this.createdDateTimeField;
            }
            set {
                this.createdDateTimeField = value;
            }
        }
        public object articleCategoryID {
            get {
                return this.articleCategoryIDField;
            }
            set {
                this.articleCategoryIDField = value;
            }
        }
        public object errorCodes {
            get {
                return this.errorCodesField;
            }
            set {
                this.errorCodesField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object keywords {
            get {
                return this.keywordsField;
            }
            set {
                this.keywordsField = value;
            }
        }
        public object lastModifiedByResourceID {
            get {
                return this.lastModifiedByResourceIDField;
            }
            set {
                this.lastModifiedByResourceIDField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object referenceLink {
            get {
                return this.referenceLinkField;
            }
            set {
                this.referenceLinkField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class KnowledgeBaseCategory {

        private object idField;
        private object descriptionField;
        private object nameField;
        private object parentCategoryIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object parentCategoryID {
            get {
                return this.parentCategoryIDField;
            }
            set {
                this.parentCategoryIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Opportunity {

        private object idField;
        private object advancedField1Field;
        private object advancedField2Field;
        private object advancedField3Field;
        private object advancedField4Field;
        private object advancedField5Field;
        private object amountField;
        private object assessmentScoreField;
        private object barriersField;
        private object closedDateField;
        private object companyIDField;
        private object contactIDField;
        private object costField;
        private object createDateField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object helpNeededField;
        private object impersonatorCreatorResourceIDField;
        private object lastActivityField;
        private object leadSourceField;
        private object lossReasonField;
        private object lossReasonDetailField;
        private object lostDateField;
        private object marketField;
        private object monthlyCostField;
        private object monthlyRevenueField;
        private object nextStepField;
        private object onetimeCostField;
        private object onetimeRevenueField;
        private object opportunityCategoryIDField;
        private object organizationalLevelAssociationIDField;
        private object ownerResourceIDField;
        private object primaryCompetitorField;
        private object probabilityField;
        private object productIDField;
        private object projectedCloseDateField;
        private object promisedFulfillmentDateField;
        private object promotionNameField;
        private object quarterlyCostField;
        private object quarterlyRevenueField;
        private object ratingField;
        private object relationshipAssessmentScoreField;
        private object revenueSpreadField;
        private object revenueSpreadUnitField;
        private object salesOrderIDField;
        private object salesProcessPercentCompleteField;
        private object semiannualCostField;
        private object semiannualRevenueField;
        private object stageField;
        private object startDateField;
        private object statusField;
        private object technicalAssessmentScoreField;
        private object throughDateField;
        private object titleField;
        private object totalAmountMonthsField;
        private object useQuoteTotalsField;
        private object winReasonField;
        private object winReasonDetailField;
        private object yearlyCostField;
        private object yearlyRevenueField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object advancedField1 {
            get {
                return this.advancedField1Field;
            }
            set {
                this.advancedField1Field = value;
            }
        }
        public object advancedField2 {
            get {
                return this.advancedField2Field;
            }
            set {
                this.advancedField2Field = value;
            }
        }
        public object advancedField3 {
            get {
                return this.advancedField3Field;
            }
            set {
                this.advancedField3Field = value;
            }
        }
        public object advancedField4 {
            get {
                return this.advancedField4Field;
            }
            set {
                this.advancedField4Field = value;
            }
        }
        public object advancedField5 {
            get {
                return this.advancedField5Field;
            }
            set {
                this.advancedField5Field = value;
            }
        }
        public object amount {
            get {
                return this.amountField;
            }
            set {
                this.amountField = value;
            }
        }
        public object assessmentScore {
            get {
                return this.assessmentScoreField;
            }
            set {
                this.assessmentScoreField = value;
            }
        }
        public object barriers {
            get {
                return this.barriersField;
            }
            set {
                this.barriersField = value;
            }
        }
        public object closedDate {
            get {
                return this.closedDateField;
            }
            set {
                this.closedDateField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object cost {
            get {
                return this.costField;
            }
            set {
                this.costField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object helpNeeded {
            get {
                return this.helpNeededField;
            }
            set {
                this.helpNeededField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object lastActivity {
            get {
                return this.lastActivityField;
            }
            set {
                this.lastActivityField = value;
            }
        }
        public object leadSource {
            get {
                return this.leadSourceField;
            }
            set {
                this.leadSourceField = value;
            }
        }
        public object lossReason {
            get {
                return this.lossReasonField;
            }
            set {
                this.lossReasonField = value;
            }
        }
        public object lossReasonDetail {
            get {
                return this.lossReasonDetailField;
            }
            set {
                this.lossReasonDetailField = value;
            }
        }
        public object lostDate {
            get {
                return this.lostDateField;
            }
            set {
                this.lostDateField = value;
            }
        }
        public object market {
            get {
                return this.marketField;
            }
            set {
                this.marketField = value;
            }
        }
        public object monthlyCost {
            get {
                return this.monthlyCostField;
            }
            set {
                this.monthlyCostField = value;
            }
        }
        public object monthlyRevenue {
            get {
                return this.monthlyRevenueField;
            }
            set {
                this.monthlyRevenueField = value;
            }
        }
        public object nextStep {
            get {
                return this.nextStepField;
            }
            set {
                this.nextStepField = value;
            }
        }
        public object onetimeCost {
            get {
                return this.onetimeCostField;
            }
            set {
                this.onetimeCostField = value;
            }
        }
        public object onetimeRevenue {
            get {
                return this.onetimeRevenueField;
            }
            set {
                this.onetimeRevenueField = value;
            }
        }
        public object opportunityCategoryID {
            get {
                return this.opportunityCategoryIDField;
            }
            set {
                this.opportunityCategoryIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object primaryCompetitor {
            get {
                return this.primaryCompetitorField;
            }
            set {
                this.primaryCompetitorField = value;
            }
        }
        public object probability {
            get {
                return this.probabilityField;
            }
            set {
                this.probabilityField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object projectedCloseDate {
            get {
                return this.projectedCloseDateField;
            }
            set {
                this.projectedCloseDateField = value;
            }
        }
        public object promisedFulfillmentDate {
            get {
                return this.promisedFulfillmentDateField;
            }
            set {
                this.promisedFulfillmentDateField = value;
            }
        }
        public object promotionName {
            get {
                return this.promotionNameField;
            }
            set {
                this.promotionNameField = value;
            }
        }
        public object quarterlyCost {
            get {
                return this.quarterlyCostField;
            }
            set {
                this.quarterlyCostField = value;
            }
        }
        public object quarterlyRevenue {
            get {
                return this.quarterlyRevenueField;
            }
            set {
                this.quarterlyRevenueField = value;
            }
        }
        public object rating {
            get {
                return this.ratingField;
            }
            set {
                this.ratingField = value;
            }
        }
        public object relationshipAssessmentScore {
            get {
                return this.relationshipAssessmentScoreField;
            }
            set {
                this.relationshipAssessmentScoreField = value;
            }
        }
        public object revenueSpread {
            get {
                return this.revenueSpreadField;
            }
            set {
                this.revenueSpreadField = value;
            }
        }
        public object revenueSpreadUnit {
            get {
                return this.revenueSpreadUnitField;
            }
            set {
                this.revenueSpreadUnitField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object salesProcessPercentComplete {
            get {
                return this.salesProcessPercentCompleteField;
            }
            set {
                this.salesProcessPercentCompleteField = value;
            }
        }
        public object semiannualCost {
            get {
                return this.semiannualCostField;
            }
            set {
                this.semiannualCostField = value;
            }
        }
        public object semiannualRevenue {
            get {
                return this.semiannualRevenueField;
            }
            set {
                this.semiannualRevenueField = value;
            }
        }
        public object stage {
            get {
                return this.stageField;
            }
            set {
                this.stageField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object technicalAssessmentScore {
            get {
                return this.technicalAssessmentScoreField;
            }
            set {
                this.technicalAssessmentScoreField = value;
            }
        }
        public object throughDate {
            get {
                return this.throughDateField;
            }
            set {
                this.throughDateField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object totalAmountMonths {
            get {
                return this.totalAmountMonthsField;
            }
            set {
                this.totalAmountMonthsField = value;
            }
        }
        public object useQuoteTotals {
            get {
                return this.useQuoteTotalsField;
            }
            set {
                this.useQuoteTotalsField = value;
            }
        }
        public object winReason {
            get {
                return this.winReasonField;
            }
            set {
                this.winReasonField = value;
            }
        }
        public object winReasonDetail {
            get {
                return this.winReasonDetailField;
            }
            set {
                this.winReasonDetailField = value;
            }
        }
        public object yearlyCost {
            get {
                return this.yearlyCostField;
            }
            set {
                this.yearlyCostField = value;
            }
        }
        public object yearlyRevenue {
            get {
                return this.yearlyRevenueField;
            }
            set {
                this.yearlyRevenueField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class OpportunityAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class OrganizationalLevel1 {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class OrganizationalLevel2 {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class OrganizationalLevelAssociation {

        private object idField;
        private object isActiveField;
        private object organizationalLevel1IDField;
        private object organizationalLevel2IDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object organizationalLevel1ID {
            get {
                return this.organizationalLevel1IDField;
            }
            set {
                this.organizationalLevel1IDField = value;
            }
        }
        public object organizationalLevel2ID {
            get {
                return this.organizationalLevel2IDField;
            }
            set {
                this.organizationalLevel2IDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PaymentTerm {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object paymentDueInDaysField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object paymentDueInDays {
            get {
                return this.paymentDueInDaysField;
            }
            set {
                this.paymentDueInDaysField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Phase {

        private object idField;
        private object createDateField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object dueDateField;
        private object estimatedHoursField;
        private object externalIDField;
        private object isScheduledField;
        private object lastActivityDateTimeField;
        private object parentPhaseIDField;
        private object phaseNumberField;
        private object projectIDField;
        private object startDateField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object dueDate {
            get {
                return this.dueDateField;
            }
            set {
                this.dueDateField = value;
            }
        }
        public object estimatedHours {
            get {
                return this.estimatedHoursField;
            }
            set {
                this.estimatedHoursField = value;
            }
        }
        public object externalID {
            get {
                return this.externalIDField;
            }
            set {
                this.externalIDField = value;
            }
        }
        public object isScheduled {
            get {
                return this.isScheduledField;
            }
            set {
                this.isScheduledField = value;
            }
        }
        public object lastActivityDateTime {
            get {
                return this.lastActivityDateTimeField;
            }
            set {
                this.lastActivityDateTimeField = value;
            }
        }
        public object parentPhaseID {
            get {
                return this.parentPhaseIDField;
            }
            set {
                this.parentPhaseIDField = value;
            }
        }
        public object phaseNumber {
            get {
                return this.phaseNumberField;
            }
            set {
                this.phaseNumberField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListMaterialCode {

        private object idField;
        private object billingCodeIDField;
        private object currencyIDField;
        private object unitPriceField;
        private object usesInternalCurrencyPriceField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListProduct {

        private object idField;
        private object currencyIDField;
        private object productIDField;
        private object unitPriceField;
        private object usesInternalCurrencyPriceField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListProductTier {

        private object idField;
        private object currencyIDField;
        private object productTierIDField;
        private object unitPriceField;
        private object usesInternalCurrencyPriceField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object productTierID {
            get {
                return this.productTierIDField;
            }
            set {
                this.productTierIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListRole {

        private object idField;
        private object currencyIDField;
        private object hourlyRateField;
        private object roleIDField;
        private object usesInternalCurrencyPriceField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object hourlyRate {
            get {
                return this.hourlyRateField;
            }
            set {
                this.hourlyRateField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListServiceBundle {

        private object idField;
        private object currencyIDField;
        private object serviceBundleIDField;
        private object unitPriceField;
        private object usesInternalCurrencyPriceField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListService {

        private object idField;
        private object currencyIDField;
        private object serviceIDField;
        private object unitPriceField;
        private object usesInternalCurrencyPriceField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PriceListWorkTypeModifier {

        private object idField;
        private object currencyIDField;
        private object modifierTypeField;
        private object modifierValueField;
        private object usesInternalCurrencyPriceField;
        private object workTypeModifierIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object currencyID {
            get {
                return this.currencyIDField;
            }
            set {
                this.currencyIDField = value;
            }
        }
        public object modifierType {
            get {
                return this.modifierTypeField;
            }
            set {
                this.modifierTypeField = value;
            }
        }
        public object modifierValue {
            get {
                return this.modifierValueField;
            }
            set {
                this.modifierValueField = value;
            }
        }
        public object usesInternalCurrencyPrice {
            get {
                return this.usesInternalCurrencyPriceField;
            }
            set {
                this.usesInternalCurrencyPriceField = value;
            }
        }
        public object workTypeModifierID {
            get {
                return this.workTypeModifierIDField;
            }
            set {
                this.workTypeModifierIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ProductNote {

        private object idField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastActivityDateField;
        private object productIDField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Product {

        private object idField;
        private object billingTypeField;
        private object chargeBillingCodeIDField;
        private object defaultVendorIDField;
        private object descriptionField;
        private object doesNotRequireProcurementField;
        private object externalProductIDField;
        private object impersonatorCreatorResourceIDField;
        private object internalProductIDField;
        private object isActiveField;
        private object isEligibleForRmaField;
        private object isSerializedField;
        private object linkField;
        private object manufacturerNameField;
        private object manufacturerProductNameField;
        private object markupRateField;
        private object msrpField;
        private object nameField;
        private object periodTypeField;
        private object priceCostMethodField;
        private object productBillingCodeIDField;
        private object productCategoryField;
        private object skuField;
        private object unitCostField;
        private object unitPriceField;
        private object vendorProductNumberField;
        private object defaultInstalledProductCategoryIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingType {
            get {
                return this.billingTypeField;
            }
            set {
                this.billingTypeField = value;
            }
        }
        public object chargeBillingCodeID {
            get {
                return this.chargeBillingCodeIDField;
            }
            set {
                this.chargeBillingCodeIDField = value;
            }
        }
        public object defaultVendorID {
            get {
                return this.defaultVendorIDField;
            }
            set {
                this.defaultVendorIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object doesNotRequireProcurement {
            get {
                return this.doesNotRequireProcurementField;
            }
            set {
                this.doesNotRequireProcurementField = value;
            }
        }
        public object externalProductID {
            get {
                return this.externalProductIDField;
            }
            set {
                this.externalProductIDField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object internalProductID {
            get {
                return this.internalProductIDField;
            }
            set {
                this.internalProductIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isEligibleForRma {
            get {
                return this.isEligibleForRmaField;
            }
            set {
                this.isEligibleForRmaField = value;
            }
        }
        public object isSerialized {
            get {
                return this.isSerializedField;
            }
            set {
                this.isSerializedField = value;
            }
        }
        public object link {
            get {
                return this.linkField;
            }
            set {
                this.linkField = value;
            }
        }
        public object manufacturerName {
            get {
                return this.manufacturerNameField;
            }
            set {
                this.manufacturerNameField = value;
            }
        }
        public object manufacturerProductName {
            get {
                return this.manufacturerProductNameField;
            }
            set {
                this.manufacturerProductNameField = value;
            }
        }
        public object markupRate {
            get {
                return this.markupRateField;
            }
            set {
                this.markupRateField = value;
            }
        }
        public object msrp {
            get {
                return this.msrpField;
            }
            set {
                this.msrpField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object periodType {
            get {
                return this.periodTypeField;
            }
            set {
                this.periodTypeField = value;
            }
        }
        public object priceCostMethod {
            get {
                return this.priceCostMethodField;
            }
            set {
                this.priceCostMethodField = value;
            }
        }
        public object productBillingCodeID {
            get {
                return this.productBillingCodeIDField;
            }
            set {
                this.productBillingCodeIDField = value;
            }
        }
        public object productCategory {
            get {
                return this.productCategoryField;
            }
            set {
                this.productCategoryField = value;
            }
        }
        public object sku {
            get {
                return this.skuField;
            }
            set {
                this.skuField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object vendorProductNumber {
            get {
                return this.vendorProductNumberField;
            }
            set {
                this.vendorProductNumberField = value;
            }
        }
        public object defaultInstalledProductCategoryID {
            get {
                return this.defaultInstalledProductCategoryIDField;
            }
            set {
                this.defaultInstalledProductCategoryIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ProductTier {

        private object idField;
        private object productIDField;
        private object unitCostField;
        private object unitPriceField;
        private object upToUnitCountField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object upToUnitCount {
            get {
                return this.upToUnitCountField;
            }
            set {
                this.upToUnitCountField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ProductVendor {

        private object idField;
        private object isActiveField;
        private object isDefaultField;
        private object productIDField;
        private object vendorCostField;
        private object vendorIDField;
        private object vendorPartNumberField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object vendorCost {
            get {
                return this.vendorCostField;
            }
            set {
                this.vendorCostField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object vendorPartNumber {
            get {
                return this.vendorPartNumberField;
            }
            set {
                this.vendorPartNumberField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ProjectAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object projectIDField;
        private object projectNoteIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object projectNoteID {
            get {
                return this.projectNoteIDField;
            }
            set {
                this.projectNoteIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ProjectCharge {

        private object idField;
        private object billableAmountField;
        private object billingCodeIDField;
        private object chargeTypeField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object datePurchasedField;
        private object descriptionField;
        private object estimatedCostField;
        private object extendedCostField;
        private object internalCurrencyBillableAmountField;
        private object internalCurrencyUnitPriceField;
        private object internalPurchaseOrderNumberField;
        private object isBillableToCompanyField;
        private object isBilledField;
        private object nameField;
        private object notesField;
        private object organizationalLevelAssociationIDField;
        private object productIDField;
        private object projectIDField;
        private object purchaseOrderNumberField;
        private object statusField;
        private object statusLastModifiedByField;
        private object statusLastModifiedDateField;
        private object unitCostField;
        private object unitPriceField;
        private object unitQuantityField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billableAmount {
            get {
                return this.billableAmountField;
            }
            set {
                this.billableAmountField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object chargeType {
            get {
                return this.chargeTypeField;
            }
            set {
                this.chargeTypeField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object estimatedCost {
            get {
                return this.estimatedCostField;
            }
            set {
                this.estimatedCostField = value;
            }
        }
        public object extendedCost {
            get {
                return this.extendedCostField;
            }
            set {
                this.extendedCostField = value;
            }
        }
        public object internalCurrencyBillableAmount {
            get {
                return this.internalCurrencyBillableAmountField;
            }
            set {
                this.internalCurrencyBillableAmountField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalPurchaseOrderNumber {
            get {
                return this.internalPurchaseOrderNumberField;
            }
            set {
                this.internalPurchaseOrderNumberField = value;
            }
        }
        public object isBillableToCompany {
            get {
                return this.isBillableToCompanyField;
            }
            set {
                this.isBillableToCompanyField = value;
            }
        }
        public object isBilled {
            get {
                return this.isBilledField;
            }
            set {
                this.isBilledField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object statusLastModifiedBy {
            get {
                return this.statusLastModifiedByField;
            }
            set {
                this.statusLastModifiedByField = value;
            }
        }
        public object statusLastModifiedDate {
            get {
                return this.statusLastModifiedDateField;
            }
            set {
                this.statusLastModifiedDateField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object unitQuantity {
            get {
                return this.unitQuantityField;
            }
            set {
                this.unitQuantityField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ProjectNoteAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object projectIDField;
        private object projectNoteIDField;
        private object publishField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object projectNoteID {
            get {
                return this.projectNoteIDField;
            }
            set {
                this.projectNoteIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ProjectNote {

        private object idField;
        private object createDateTimeField;
        private object createdByContactIDField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object isAnnouncementField;
        private object lastActivityDateField;
        private object noteTypeField;
        private object projectIDField;
        private object publishField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object createdByContactID {
            get {
                return this.createdByContactIDField;
            }
            set {
                this.createdByContactIDField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object isAnnouncement {
            get {
                return this.isAnnouncementField;
            }
            set {
                this.isAnnouncementField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object noteType {
            get {
                return this.noteTypeField;
            }
            set {
                this.noteTypeField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Project {

        private object idField;
        private object actualBilledHoursField;
        private object actualHoursField;
        private object changeOrdersBudgetField;
        private object changeOrdersRevenueField;
        private object companyIDField;
        private object companyOwnerResourceIDField;
        private object completedDateTimeField;
        private object completedPercentageField;
        private object contractIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object departmentField;
        private object descriptionField;
        private object durationField;
        private object endDateTimeField;
        private object estimatedSalesCostField;
        private object estimatedTimeField;
        private object extProjectNumberField;
        private object extProjectTypeField;
        private object impersonatorCreatorResourceIDField;
        private object laborEstimatedCostsField;
        private object laborEstimatedMarginPercentageField;
        private object laborEstimatedRevenueField;
        private object lastActivityDateTimeField;
        private object lastActivityPersonTypeField;
        private object lastActivityResourceIDField;
        private object opportunityIDField;
        private object organizationalLevelAssociationIDField;
        private object originalEstimatedRevenueField;
        private object projectCostEstimatedMarginPercentageField;
        private object projectCostsBudgetField;
        private object projectCostsRevenueField;
        private object projectLeadResourceIDField;
        private object projectNameField;
        private object projectNumberField;
        private object projectTypeField;
        private object purchaseOrderNumberField;
        private object sgdaField;
        private object startDateTimeField;
        private object statusField;
        private object statusDateTimeField;
        private object statusDetailField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object actualBilledHours {
            get {
                return this.actualBilledHoursField;
            }
            set {
                this.actualBilledHoursField = value;
            }
        }
        public object actualHours {
            get {
                return this.actualHoursField;
            }
            set {
                this.actualHoursField = value;
            }
        }
        public object changeOrdersBudget {
            get {
                return this.changeOrdersBudgetField;
            }
            set {
                this.changeOrdersBudgetField = value;
            }
        }
        public object changeOrdersRevenue {
            get {
                return this.changeOrdersRevenueField;
            }
            set {
                this.changeOrdersRevenueField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyOwnerResourceID {
            get {
                return this.companyOwnerResourceIDField;
            }
            set {
                this.companyOwnerResourceIDField = value;
            }
        }
        public object completedDateTime {
            get {
                return this.completedDateTimeField;
            }
            set {
                this.completedDateTimeField = value;
            }
        }
        public object completedPercentage {
            get {
                return this.completedPercentageField;
            }
            set {
                this.completedPercentageField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object department {
            get {
                return this.departmentField;
            }
            set {
                this.departmentField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object duration {
            get {
                return this.durationField;
            }
            set {
                this.durationField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object estimatedSalesCost {
            get {
                return this.estimatedSalesCostField;
            }
            set {
                this.estimatedSalesCostField = value;
            }
        }
        public object estimatedTime {
            get {
                return this.estimatedTimeField;
            }
            set {
                this.estimatedTimeField = value;
            }
        }
        public object extProjectNumber {
            get {
                return this.extProjectNumberField;
            }
            set {
                this.extProjectNumberField = value;
            }
        }
        public object extProjectType {
            get {
                return this.extProjectTypeField;
            }
            set {
                this.extProjectTypeField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object laborEstimatedCosts {
            get {
                return this.laborEstimatedCostsField;
            }
            set {
                this.laborEstimatedCostsField = value;
            }
        }
        public object laborEstimatedMarginPercentage {
            get {
                return this.laborEstimatedMarginPercentageField;
            }
            set {
                this.laborEstimatedMarginPercentageField = value;
            }
        }
        public object laborEstimatedRevenue {
            get {
                return this.laborEstimatedRevenueField;
            }
            set {
                this.laborEstimatedRevenueField = value;
            }
        }
        public object lastActivityDateTime {
            get {
                return this.lastActivityDateTimeField;
            }
            set {
                this.lastActivityDateTimeField = value;
            }
        }
        public object lastActivityPersonType {
            get {
                return this.lastActivityPersonTypeField;
            }
            set {
                this.lastActivityPersonTypeField = value;
            }
        }
        public object lastActivityResourceID {
            get {
                return this.lastActivityResourceIDField;
            }
            set {
                this.lastActivityResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object originalEstimatedRevenue {
            get {
                return this.originalEstimatedRevenueField;
            }
            set {
                this.originalEstimatedRevenueField = value;
            }
        }
        public object projectCostEstimatedMarginPercentage {
            get {
                return this.projectCostEstimatedMarginPercentageField;
            }
            set {
                this.projectCostEstimatedMarginPercentageField = value;
            }
        }
        public object projectCostsBudget {
            get {
                return this.projectCostsBudgetField;
            }
            set {
                this.projectCostsBudgetField = value;
            }
        }
        public object projectCostsRevenue {
            get {
                return this.projectCostsRevenueField;
            }
            set {
                this.projectCostsRevenueField = value;
            }
        }
        public object projectLeadResourceID {
            get {
                return this.projectLeadResourceIDField;
            }
            set {
                this.projectLeadResourceIDField = value;
            }
        }
        public object projectName {
            get {
                return this.projectNameField;
            }
            set {
                this.projectNameField = value;
            }
        }
        public object projectNumber {
            get {
                return this.projectNumberField;
            }
            set {
                this.projectNumberField = value;
            }
        }
        public object projectType {
            get {
                return this.projectTypeField;
            }
            set {
                this.projectTypeField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object sgda {
            get {
                return this.sgdaField;
            }
            set {
                this.sgdaField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object statusDateTime {
            get {
                return this.statusDateTimeField;
            }
            set {
                this.statusDateTimeField = value;
            }
        }
        public object statusDetail {
            get {
                return this.statusDetailField;
            }
            set {
                this.statusDetailField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PurchaseApproval {

        private object idField;
        private object costTypeField;
        private object isApprovedField;
        private object rejectNoteField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object costType {
            get {
                return this.costTypeField;
            }
            set {
                this.costTypeField = value;
            }
        }
        public object isApproved {
            get {
                return this.isApprovedField;
            }
            set {
                this.isApprovedField = value;
            }
        }
        public object rejectNote {
            get {
                return this.rejectNoteField;
            }
            set {
                this.rejectNoteField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PurchaseOrderItemReceiving {

        private object idField;
        private object purchaseOrderItemIDField;
        private object quantityBackOrderedField;
        private object quantityNowReceivingField;
        private object quantityPreviouslyReceivedField;
        private object receiveDateField;
        private object receivedByResourceIDField;
        private object serialNumberField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object purchaseOrderItemID {
            get {
                return this.purchaseOrderItemIDField;
            }
            set {
                this.purchaseOrderItemIDField = value;
            }
        }
        public object quantityBackOrdered {
            get {
                return this.quantityBackOrderedField;
            }
            set {
                this.quantityBackOrderedField = value;
            }
        }
        public object quantityNowReceiving {
            get {
                return this.quantityNowReceivingField;
            }
            set {
                this.quantityNowReceivingField = value;
            }
        }
        public object quantityPreviouslyReceived {
            get {
                return this.quantityPreviouslyReceivedField;
            }
            set {
                this.quantityPreviouslyReceivedField = value;
            }
        }
        public object receiveDate {
            get {
                return this.receiveDateField;
            }
            set {
                this.receiveDateField = value;
            }
        }
        public object receivedByResourceID {
            get {
                return this.receivedByResourceIDField;
            }
            set {
                this.receivedByResourceIDField = value;
            }
        }
        public object serialNumber {
            get {
                return this.serialNumberField;
            }
            set {
                this.serialNumberField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PurchaseOrderItem {

        private object idField;
        private object chargeIDField;
        private object contractIDField;
        private object estimatedArrivalDateField;
        private object internalCurrencyUnitCostField;
        private object inventoryLocationIDField;
        private object memoField;
        private object orderIDField;
        private object productIDField;
        private object projectIDField;
        private object quantityField;
        private object salesOrderIDField;
        private object ticketIDField;
        private object unitCostField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object chargeID {
            get {
                return this.chargeIDField;
            }
            set {
                this.chargeIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object estimatedArrivalDate {
            get {
                return this.estimatedArrivalDateField;
            }
            set {
                this.estimatedArrivalDateField = value;
            }
        }
        public object internalCurrencyUnitCost {
            get {
                return this.internalCurrencyUnitCostField;
            }
            set {
                this.internalCurrencyUnitCostField = value;
            }
        }
        public object inventoryLocationID {
            get {
                return this.inventoryLocationIDField;
            }
            set {
                this.inventoryLocationIDField = value;
            }
        }
        public object memo {
            get {
                return this.memoField;
            }
            set {
                this.memoField = value;
            }
        }
        public object orderID {
            get {
                return this.orderIDField;
            }
            set {
                this.orderIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object quantity {
            get {
                return this.quantityField;
            }
            set {
                this.quantityField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class PurchaseOrder {

        private object idField;
        private object cancelDateTimeField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object externalPONumberField;
        private object faxField;
        private object freightField;
        private object generalMemoField;
        private object impersonatorCreatorResourceIDField;
        private object internalCurrencyFreightField;
        private object latestEstimatedArrivalDateField;
        private object paymentTermField;
        private object phoneField;
        private object purchaseForCompanyIDField;
        private object purchaseOrderNumberField;
        private object purchaseOrderTemplateIDField;
        private object shippingDateField;
        private object shippingTypeField;
        private object shipToAddress1Field;
        private object shipToAddress2Field;
        private object shipToCityField;
        private object shipToNameField;
        private object shipToPostalCodeField;
        private object shipToStateField;
        private object showEachTaxInGroupField;
        private object showTaxCategoryField;
        private object statusField;
        private object submitDateTimeField;
        private object taxRegionIDField;
        private object useItemDescriptionsFromField;
        private object vendorIDField;
        private object vendorInvoiceNumberField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object cancelDateTime {
            get {
                return this.cancelDateTimeField;
            }
            set {
                this.cancelDateTimeField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object externalPONumber {
            get {
                return this.externalPONumberField;
            }
            set {
                this.externalPONumberField = value;
            }
        }
        public object fax {
            get {
                return this.faxField;
            }
            set {
                this.faxField = value;
            }
        }
        public object freight {
            get {
                return this.freightField;
            }
            set {
                this.freightField = value;
            }
        }
        public object generalMemo {
            get {
                return this.generalMemoField;
            }
            set {
                this.generalMemoField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object internalCurrencyFreight {
            get {
                return this.internalCurrencyFreightField;
            }
            set {
                this.internalCurrencyFreightField = value;
            }
        }
        public object latestEstimatedArrivalDate {
            get {
                return this.latestEstimatedArrivalDateField;
            }
            set {
                this.latestEstimatedArrivalDateField = value;
            }
        }
        public object paymentTerm {
            get {
                return this.paymentTermField;
            }
            set {
                this.paymentTermField = value;
            }
        }
        public object phone {
            get {
                return this.phoneField;
            }
            set {
                this.phoneField = value;
            }
        }
        public object purchaseForCompanyID {
            get {
                return this.purchaseForCompanyIDField;
            }
            set {
                this.purchaseForCompanyIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object purchaseOrderTemplateID {
            get {
                return this.purchaseOrderTemplateIDField;
            }
            set {
                this.purchaseOrderTemplateIDField = value;
            }
        }
        public object shippingDate {
            get {
                return this.shippingDateField;
            }
            set {
                this.shippingDateField = value;
            }
        }
        public object shippingType {
            get {
                return this.shippingTypeField;
            }
            set {
                this.shippingTypeField = value;
            }
        }
        public object shipToAddress1 {
            get {
                return this.shipToAddress1Field;
            }
            set {
                this.shipToAddress1Field = value;
            }
        }
        public object shipToAddress2 {
            get {
                return this.shipToAddress2Field;
            }
            set {
                this.shipToAddress2Field = value;
            }
        }
        public object shipToCity {
            get {
                return this.shipToCityField;
            }
            set {
                this.shipToCityField = value;
            }
        }
        public object shipToName {
            get {
                return this.shipToNameField;
            }
            set {
                this.shipToNameField = value;
            }
        }
        public object shipToPostalCode {
            get {
                return this.shipToPostalCodeField;
            }
            set {
                this.shipToPostalCodeField = value;
            }
        }
        public object shipToState {
            get {
                return this.shipToStateField;
            }
            set {
                this.shipToStateField = value;
            }
        }
        public object showEachTaxInGroup {
            get {
                return this.showEachTaxInGroupField;
            }
            set {
                this.showEachTaxInGroupField = value;
            }
        }
        public object showTaxCategory {
            get {
                return this.showTaxCategoryField;
            }
            set {
                this.showTaxCategoryField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object submitDateTime {
            get {
                return this.submitDateTimeField;
            }
            set {
                this.submitDateTimeField = value;
            }
        }
        public object taxRegionID {
            get {
                return this.taxRegionIDField;
            }
            set {
                this.taxRegionIDField = value;
            }
        }
        public object useItemDescriptionsFrom {
            get {
                return this.useItemDescriptionsFromField;
            }
            set {
                this.useItemDescriptionsFromField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object vendorInvoiceNumber {
            get {
                return this.vendorInvoiceNumberField;
            }
            set {
                this.vendorInvoiceNumberField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class QuoteItem {

        private object idField;
        private object averageCostField;
        private object chargeIDField;
        private object descriptionField;
        private object expenseIDField;
        private object highestCostField;
        private object internalCurrencyLineDiscountField;
        private object internalCurrencyUnitDiscountField;
        private object internalCurrencyUnitPriceField;
        private object isOptionalField;
        private object isTaxableField;
        private object laborIDField;
        private object lineDiscountField;
        private object markupRateField;
        private object nameField;
        private object percentageDiscountField;
        private object periodTypeField;
        private object productIDField;
        private object quantityField;
        private object quoteIDField;
        private object quoteItemTypeField;
        private object serviceBundleIDField;
        private object serviceIDField;
        private object shippingIDField;
        private object sortOrderIDField;
        private object taxCategoryIDField;
        private object totalEffectiveTaxField;
        private object unitCostField;
        private object unitDiscountField;
        private object unitPriceField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object averageCost {
            get {
                return this.averageCostField;
            }
            set {
                this.averageCostField = value;
            }
        }
        public object chargeID {
            get {
                return this.chargeIDField;
            }
            set {
                this.chargeIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object expenseID {
            get {
                return this.expenseIDField;
            }
            set {
                this.expenseIDField = value;
            }
        }
        public object highestCost {
            get {
                return this.highestCostField;
            }
            set {
                this.highestCostField = value;
            }
        }
        public object internalCurrencyLineDiscount {
            get {
                return this.internalCurrencyLineDiscountField;
            }
            set {
                this.internalCurrencyLineDiscountField = value;
            }
        }
        public object internalCurrencyUnitDiscount {
            get {
                return this.internalCurrencyUnitDiscountField;
            }
            set {
                this.internalCurrencyUnitDiscountField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object isOptional {
            get {
                return this.isOptionalField;
            }
            set {
                this.isOptionalField = value;
            }
        }
        public object isTaxable {
            get {
                return this.isTaxableField;
            }
            set {
                this.isTaxableField = value;
            }
        }
        public object laborID {
            get {
                return this.laborIDField;
            }
            set {
                this.laborIDField = value;
            }
        }
        public object lineDiscount {
            get {
                return this.lineDiscountField;
            }
            set {
                this.lineDiscountField = value;
            }
        }
        public object markupRate {
            get {
                return this.markupRateField;
            }
            set {
                this.markupRateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object percentageDiscount {
            get {
                return this.percentageDiscountField;
            }
            set {
                this.percentageDiscountField = value;
            }
        }
        public object periodType {
            get {
                return this.periodTypeField;
            }
            set {
                this.periodTypeField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object quantity {
            get {
                return this.quantityField;
            }
            set {
                this.quantityField = value;
            }
        }
        public object quoteID {
            get {
                return this.quoteIDField;
            }
            set {
                this.quoteIDField = value;
            }
        }
        public object quoteItemType {
            get {
                return this.quoteItemTypeField;
            }
            set {
                this.quoteItemTypeField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object shippingID {
            get {
                return this.shippingIDField;
            }
            set {
                this.shippingIDField = value;
            }
        }
        public object sortOrderID {
            get {
                return this.sortOrderIDField;
            }
            set {
                this.sortOrderIDField = value;
            }
        }
        public object taxCategoryID {
            get {
                return this.taxCategoryIDField;
            }
            set {
                this.taxCategoryIDField = value;
            }
        }
        public object totalEffectiveTax {
            get {
                return this.totalEffectiveTaxField;
            }
            set {
                this.totalEffectiveTaxField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitDiscount {
            get {
                return this.unitDiscountField;
            }
            set {
                this.unitDiscountField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class QuoteLocation {

        private object idField;
        private object address1Field;
        private object address2Field;
        private object cityField;
        private object postalCodeField;
        private object stateField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object address1 {
            get {
                return this.address1Field;
            }
            set {
                this.address1Field = value;
            }
        }
        public object address2 {
            get {
                return this.address2Field;
            }
            set {
                this.address2Field = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object postalCode {
            get {
                return this.postalCodeField;
            }
            set {
                this.postalCodeField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Quote {

        private object idField;
        private object approvalStatusField;
        private object approvalStatusChangedByResourceIDField;
        private object approvalStatusChangedDateField;
        private object billToLocationIDField;
        private object calculateTaxSeparatelyField;
        private object commentField;
        private object companyIDField;
        private object contactIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object effectiveDateField;
        private object expirationDateField;
        private object extApprovalContactResponseField;
        private object extApprovalResponseDateField;
        private object extApprovalResponseSignatureField;
        private object externalQuoteNumberField;
        private object groupByIDField;
        private object impersonatorCreatorResourceIDField;
        private object isActiveField;
        private object lastActivityDateField;
        private object lastModifiedByField;
        private object nameField;
        private object opportunityIDField;
        private object paymentTermField;
        private object paymentTypeField;
        private object primaryQuoteField;
        private object proposalProjectIDField;
        private object purchaseOrderNumberField;
        private object quoteNumberField;
        private object quoteTemplateIDField;
        private object shippingTypeField;
        private object shipToLocationIDField;
        private object showEachTaxInGroupField;
        private object showTaxCategoryField;
        private object soldToLocationIDField;
        private object taxRegionIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object approvalStatus {
            get {
                return this.approvalStatusField;
            }
            set {
                this.approvalStatusField = value;
            }
        }
        public object approvalStatusChangedByResourceID {
            get {
                return this.approvalStatusChangedByResourceIDField;
            }
            set {
                this.approvalStatusChangedByResourceIDField = value;
            }
        }
        public object approvalStatusChangedDate {
            get {
                return this.approvalStatusChangedDateField;
            }
            set {
                this.approvalStatusChangedDateField = value;
            }
        }
        public object billToLocationID {
            get {
                return this.billToLocationIDField;
            }
            set {
                this.billToLocationIDField = value;
            }
        }
        public object calculateTaxSeparately {
            get {
                return this.calculateTaxSeparatelyField;
            }
            set {
                this.calculateTaxSeparatelyField = value;
            }
        }
        public object comment {
            get {
                return this.commentField;
            }
            set {
                this.commentField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object expirationDate {
            get {
                return this.expirationDateField;
            }
            set {
                this.expirationDateField = value;
            }
        }
        public object extApprovalContactResponse {
            get {
                return this.extApprovalContactResponseField;
            }
            set {
                this.extApprovalContactResponseField = value;
            }
        }
        public object extApprovalResponseDate {
            get {
                return this.extApprovalResponseDateField;
            }
            set {
                this.extApprovalResponseDateField = value;
            }
        }
        public object extApprovalResponseSignature {
            get {
                return this.extApprovalResponseSignatureField;
            }
            set {
                this.extApprovalResponseSignatureField = value;
            }
        }
        public object externalQuoteNumber {
            get {
                return this.externalQuoteNumberField;
            }
            set {
                this.externalQuoteNumberField = value;
            }
        }
        public object groupByID {
            get {
                return this.groupByIDField;
            }
            set {
                this.groupByIDField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object lastModifiedBy {
            get {
                return this.lastModifiedByField;
            }
            set {
                this.lastModifiedByField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object paymentTerm {
            get {
                return this.paymentTermField;
            }
            set {
                this.paymentTermField = value;
            }
        }
        public object paymentType {
            get {
                return this.paymentTypeField;
            }
            set {
                this.paymentTypeField = value;
            }
        }
        public object primaryQuote {
            get {
                return this.primaryQuoteField;
            }
            set {
                this.primaryQuoteField = value;
            }
        }
        public object proposalProjectID {
            get {
                return this.proposalProjectIDField;
            }
            set {
                this.proposalProjectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object quoteNumber {
            get {
                return this.quoteNumberField;
            }
            set {
                this.quoteNumberField = value;
            }
        }
        public object quoteTemplateID {
            get {
                return this.quoteTemplateIDField;
            }
            set {
                this.quoteTemplateIDField = value;
            }
        }
        public object shippingType {
            get {
                return this.shippingTypeField;
            }
            set {
                this.shippingTypeField = value;
            }
        }
        public object shipToLocationID {
            get {
                return this.shipToLocationIDField;
            }
            set {
                this.shipToLocationIDField = value;
            }
        }
        public object showEachTaxInGroup {
            get {
                return this.showEachTaxInGroupField;
            }
            set {
                this.showEachTaxInGroupField = value;
            }
        }
        public object showTaxCategory {
            get {
                return this.showTaxCategoryField;
            }
            set {
                this.showTaxCategoryField = value;
            }
        }
        public object soldToLocationID {
            get {
                return this.soldToLocationIDField;
            }
            set {
                this.soldToLocationIDField = value;
            }
        }
        public object taxRegionID {
            get {
                return this.taxRegionIDField;
            }
            set {
                this.taxRegionIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ResourceAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object resourceIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class ResourceRoleDepartment {

        private object idField;
        private object departmentIDField;
        private object isActiveField;
        private object isDefaultField;
        private object isDepartmentLeadField;
        private object resourceIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object departmentID {
            get {
                return this.departmentIDField;
            }
            set {
                this.departmentIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object isDepartmentLead {
            get {
                return this.isDepartmentLeadField;
            }
            set {
                this.isDepartmentLeadField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ResourceRoleQueue {

        private object idField;
        private object queueIDField;
        private object resourceIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object queueID {
            get {
                return this.queueIDField;
            }
            set {
                this.queueIDField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Resource {

        private object idField;
        private object accountingReferenceIDField;
        private object dateFormatField;
        private object defaultServiceDeskRoleIDField;
        private object emailField;
        private object email2Field;
        private object email3Field;
        private object emailTypeCodeField;
        private object emailTypeCode2Field;
        private object emailTypeCode3Field;
        private object firstNameField;
        private object genderField;
        private object greetingField;
        private object hireDateField;
        private object homePhoneField;
        private object initialsField;
        private object internalCostField;
        private object isActiveField;
        private object lastNameField;
        private object licenseTypeField;
        private object locationIDField;
        private object middleNameField;
        private object mobilePhoneField;
        private object numberFormatField;
        private object officeExtensionField;
        private object officePhoneField;
        private object payrollTypeField;
        private object resourceTypeField;
        private object suffixField;
        private object surveyResourceRatingField;
        private object timeFormatField;
        private object titleField;
        private object travelAvailabilityPctField;
        private object userNameField;
        private object userTypeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object accountingReferenceID {
            get {
                return this.accountingReferenceIDField;
            }
            set {
                this.accountingReferenceIDField = value;
            }
        }
        public object dateFormat {
            get {
                return this.dateFormatField;
            }
            set {
                this.dateFormatField = value;
            }
        }
        public object defaultServiceDeskRoleID {
            get {
                return this.defaultServiceDeskRoleIDField;
            }
            set {
                this.defaultServiceDeskRoleIDField = value;
            }
        }
        public object email {
            get {
                return this.emailField;
            }
            set {
                this.emailField = value;
            }
        }
        public object email2 {
            get {
                return this.email2Field;
            }
            set {
                this.email2Field = value;
            }
        }
        public object email3 {
            get {
                return this.email3Field;
            }
            set {
                this.email3Field = value;
            }
        }
        public object emailTypeCode {
            get {
                return this.emailTypeCodeField;
            }
            set {
                this.emailTypeCodeField = value;
            }
        }
        public object emailTypeCode2 {
            get {
                return this.emailTypeCode2Field;
            }
            set {
                this.emailTypeCode2Field = value;
            }
        }
        public object emailTypeCode3 {
            get {
                return this.emailTypeCode3Field;
            }
            set {
                this.emailTypeCode3Field = value;
            }
        }
        public object firstName {
            get {
                return this.firstNameField;
            }
            set {
                this.firstNameField = value;
            }
        }
        public object gender {
            get {
                return this.genderField;
            }
            set {
                this.genderField = value;
            }
        }
        public object greeting {
            get {
                return this.greetingField;
            }
            set {
                this.greetingField = value;
            }
        }
        public object hireDate {
            get {
                return this.hireDateField;
            }
            set {
                this.hireDateField = value;
            }
        }
        public object homePhone {
            get {
                return this.homePhoneField;
            }
            set {
                this.homePhoneField = value;
            }
        }
        public object initials {
            get {
                return this.initialsField;
            }
            set {
                this.initialsField = value;
            }
        }
        public object internalCost {
            get {
                return this.internalCostField;
            }
            set {
                this.internalCostField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastName {
            get {
                return this.lastNameField;
            }
            set {
                this.lastNameField = value;
            }
        }
        public object licenseType {
            get {
                return this.licenseTypeField;
            }
            set {
                this.licenseTypeField = value;
            }
        }
        public object locationID {
            get {
                return this.locationIDField;
            }
            set {
                this.locationIDField = value;
            }
        }
        public object middleName {
            get {
                return this.middleNameField;
            }
            set {
                this.middleNameField = value;
            }
        }
        public object mobilePhone {
            get {
                return this.mobilePhoneField;
            }
            set {
                this.mobilePhoneField = value;
            }
        }
        public object numberFormat {
            get {
                return this.numberFormatField;
            }
            set {
                this.numberFormatField = value;
            }
        }
        public object officeExtension {
            get {
                return this.officeExtensionField;
            }
            set {
                this.officeExtensionField = value;
            }
        }
        public object officePhone {
            get {
                return this.officePhoneField;
            }
            set {
                this.officePhoneField = value;
            }
        }
        public object payrollType {
            get {
                return this.payrollTypeField;
            }
            set {
                this.payrollTypeField = value;
            }
        }
        public object resourceType {
            get {
                return this.resourceTypeField;
            }
            set {
                this.resourceTypeField = value;
            }
        }
        public object suffix {
            get {
                return this.suffixField;
            }
            set {
                this.suffixField = value;
            }
        }
        public object surveyResourceRating {
            get {
                return this.surveyResourceRatingField;
            }
            set {
                this.surveyResourceRatingField = value;
            }
        }
        public object timeFormat {
            get {
                return this.timeFormatField;
            }
            set {
                this.timeFormatField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object travelAvailabilityPct {
            get {
                return this.travelAvailabilityPctField;
            }
            set {
                this.travelAvailabilityPctField = value;
            }
        }
        public object userName {
            get {
                return this.userNameField;
            }
            set {
                this.userNameField = value;
            }
        }
        public object userType {
            get {
                return this.userTypeField;
            }
            set {
                this.userTypeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ResourceServiceDeskRole {

        private object idField;
        private object isActiveField;
        private object isDefaultField;
        private object resourceIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ResourceSkill {

        private object idField;
        private object resourceIDField;
        private object skillDescriptionField;
        private object skillIDField;
        private object skillLevelField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object skillDescription {
            get {
                return this.skillDescriptionField;
            }
            set {
                this.skillDescriptionField = value;
            }
        }
        public object skillID {
            get {
                return this.skillIDField;
            }
            set {
                this.skillIDField = value;
            }
        }
        public object skillLevel {
            get {
                return this.skillLevelField;
            }
            set {
                this.skillLevelField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Role {

        private object idField;
        private object descriptionField;
        private object hourlyFactorField;
        private object hourlyRateField;
        private object isActiveField;
        private object isExcludedFromNewContractsField;
        private object isSystemRoleField;
        private object nameField;
        private object quoteItemDefaultTaxCategoryIdField;
        private object roleTypeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object hourlyFactor {
            get {
                return this.hourlyFactorField;
            }
            set {
                this.hourlyFactorField = value;
            }
        }
        public object hourlyRate {
            get {
                return this.hourlyRateField;
            }
            set {
                this.hourlyRateField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isExcludedFromNewContracts {
            get {
                return this.isExcludedFromNewContractsField;
            }
            set {
                this.isExcludedFromNewContractsField = value;
            }
        }
        public object isSystemRole {
            get {
                return this.isSystemRoleField;
            }
            set {
                this.isSystemRoleField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object quoteItemDefaultTaxCategoryId {
            get {
                return this.quoteItemDefaultTaxCategoryIdField;
            }
            set {
                this.quoteItemDefaultTaxCategoryIdField = value;
            }
        }
        public object roleType {
            get {
                return this.roleTypeField;
            }
            set {
                this.roleTypeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class SalesOrderAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object salesOrderIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class SalesOrder {

        private object idField;
        private object additionalBillToAddressInformationField;
        private object additionalShipToAddressInformationField;
        private object billingAddress1Field;
        private object billingAddress2Field;
        private object billToCityField;
        private object billToCountryIDField;
        private object billToPostalCodeField;
        private object billToStateField;
        private object companyIDField;
        private object contactIDField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object organizationalLevelAssociationIDField;
        private object ownerResourceIDField;
        private object promisedFulfillmentDateField;
        private object salesOrderDateField;
        private object shipToAddress1Field;
        private object shipToAddress2Field;
        private object shipToCityField;
        private object shipToCountryIDField;
        private object shipToPostalCodeField;
        private object shipToStateField;
        private object statusField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalBillToAddressInformation {
            get {
                return this.additionalBillToAddressInformationField;
            }
            set {
                this.additionalBillToAddressInformationField = value;
            }
        }
        public object additionalShipToAddressInformation {
            get {
                return this.additionalShipToAddressInformationField;
            }
            set {
                this.additionalShipToAddressInformationField = value;
            }
        }
        public object billingAddress1 {
            get {
                return this.billingAddress1Field;
            }
            set {
                this.billingAddress1Field = value;
            }
        }
        public object billingAddress2 {
            get {
                return this.billingAddress2Field;
            }
            set {
                this.billingAddress2Field = value;
            }
        }
        public object billToCity {
            get {
                return this.billToCityField;
            }
            set {
                this.billToCityField = value;
            }
        }
        public object billToCountryID {
            get {
                return this.billToCountryIDField;
            }
            set {
                this.billToCountryIDField = value;
            }
        }
        public object billToPostalCode {
            get {
                return this.billToPostalCodeField;
            }
            set {
                this.billToPostalCodeField = value;
            }
        }
        public object billToState {
            get {
                return this.billToStateField;
            }
            set {
                this.billToStateField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object ownerResourceID {
            get {
                return this.ownerResourceIDField;
            }
            set {
                this.ownerResourceIDField = value;
            }
        }
        public object promisedFulfillmentDate {
            get {
                return this.promisedFulfillmentDateField;
            }
            set {
                this.promisedFulfillmentDateField = value;
            }
        }
        public object salesOrderDate {
            get {
                return this.salesOrderDateField;
            }
            set {
                this.salesOrderDateField = value;
            }
        }
        public object shipToAddress1 {
            get {
                return this.shipToAddress1Field;
            }
            set {
                this.shipToAddress1Field = value;
            }
        }
        public object shipToAddress2 {
            get {
                return this.shipToAddress2Field;
            }
            set {
                this.shipToAddress2Field = value;
            }
        }
        public object shipToCity {
            get {
                return this.shipToCityField;
            }
            set {
                this.shipToCityField = value;
            }
        }
        public object shipToCountryID {
            get {
                return this.shipToCountryIDField;
            }
            set {
                this.shipToCountryIDField = value;
            }
        }
        public object shipToPostalCode {
            get {
                return this.shipToPostalCodeField;
            }
            set {
                this.shipToPostalCodeField = value;
            }
        }
        public object shipToState {
            get {
                return this.shipToStateField;
            }
            set {
                this.shipToStateField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceBundle {

        private object idField;
        private object billingCodeIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object invoiceDescriptionField;
        private object isActiveField;
        private object lastModifiedDateField;
        private object nameField;
        private object percentageDiscountField;
        private object periodTypeField;
        private object serviceLevelAgreementIDField;
        private object unitCostField;
        private object unitDiscountField;
        private object unitPriceField;
        private object updateResourceIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object invoiceDescription {
            get {
                return this.invoiceDescriptionField;
            }
            set {
                this.invoiceDescriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastModifiedDate {
            get {
                return this.lastModifiedDateField;
            }
            set {
                this.lastModifiedDateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object percentageDiscount {
            get {
                return this.percentageDiscountField;
            }
            set {
                this.percentageDiscountField = value;
            }
        }
        public object periodType {
            get {
                return this.periodTypeField;
            }
            set {
                this.periodTypeField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitDiscount {
            get {
                return this.unitDiscountField;
            }
            set {
                this.unitDiscountField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object updateResourceID {
            get {
                return this.updateResourceIDField;
            }
            set {
                this.updateResourceIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceBundleService {

        private object idField;
        private object serviceBundleIDField;
        private object serviceIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceCall {

        private object idField;
        private object cancelationNoticeHoursField;
        private object canceledByResourceIDField;
        private object canceledDateTimeField;
        private object companyIDField;
        private object companyLocationIDField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object durationField;
        private object endDateTimeField;
        private object impersonatorCreatorResourceIDField;
        private object isCompleteField;
        private object lastModifiedDateTimeField;
        private object startDateTimeField;
        private object statusField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object cancelationNoticeHours {
            get {
                return this.cancelationNoticeHoursField;
            }
            set {
                this.cancelationNoticeHoursField = value;
            }
        }
        public object canceledByResourceID {
            get {
                return this.canceledByResourceIDField;
            }
            set {
                this.canceledByResourceIDField = value;
            }
        }
        public object canceledDateTime {
            get {
                return this.canceledDateTimeField;
            }
            set {
                this.canceledDateTimeField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object duration {
            get {
                return this.durationField;
            }
            set {
                this.durationField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object isComplete {
            get {
                return this.isCompleteField;
            }
            set {
                this.isCompleteField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceCallTaskResource {

        private object idField;
        private object resourceIDField;
        private object serviceCallTaskIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object serviceCallTaskID {
            get {
                return this.serviceCallTaskIDField;
            }
            set {
                this.serviceCallTaskIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceCallTask {

        private object idField;
        private object serviceCallIDField;
        private object taskIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object serviceCallID {
            get {
                return this.serviceCallIDField;
            }
            set {
                this.serviceCallIDField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceCallTicketResource {

        private object idField;
        private object resourceIDField;
        private object serviceCallTicketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object serviceCallTicketID {
            get {
                return this.serviceCallTicketIDField;
            }
            set {
                this.serviceCallTicketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceCallTicket {

        private object idField;
        private object serviceCallIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object serviceCallID {
            get {
                return this.serviceCallIDField;
            }
            set {
                this.serviceCallIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Service {

        private object idField;
        private object billingCodeIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object invoiceDescriptionField;
        private object isActiveField;
        private object lastModifiedDateField;
        private object markupRateField;
        private object nameField;
        private object periodTypeField;
        private object serviceLevelAgreementIDField;
        private object unitCostField;
        private object unitPriceField;
        private object updateResourceIDField;
        private object vendorCompanyIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object invoiceDescription {
            get {
                return this.invoiceDescriptionField;
            }
            set {
                this.invoiceDescriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastModifiedDate {
            get {
                return this.lastModifiedDateField;
            }
            set {
                this.lastModifiedDateField = value;
            }
        }
        public object markupRate {
            get {
                return this.markupRateField;
            }
            set {
                this.markupRateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object periodType {
            get {
                return this.periodTypeField;
            }
            set {
                this.periodTypeField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object updateResourceID {
            get {
                return this.updateResourceIDField;
            }
            set {
                this.updateResourceIDField = value;
            }
        }
        public object vendorCompanyID {
            get {
                return this.vendorCompanyIDField;
            }
            set {
                this.vendorCompanyIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Subscription {

        private object idField;
        private object configurationItemIDField;
        private object descriptionField;
        private object effectiveDateField;
        private object expirationDateField;
        private object impersonatorCreatorResourceIDField;
        private object materialCodeIDField;
        private object organizationalLevelAssociationIDField;
        private object periodCostField;
        private object periodPriceField;
        private object periodTypeField;
        private object purchaseOrderNumberField;
        private object statusField;
        private object subscriptionNameField;
        private object totalCostField;
        private object totalPriceField;
        private object vendorIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object effectiveDate {
            get {
                return this.effectiveDateField;
            }
            set {
                this.effectiveDateField = value;
            }
        }
        public object expirationDate {
            get {
                return this.expirationDateField;
            }
            set {
                this.expirationDateField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object materialCodeID {
            get {
                return this.materialCodeIDField;
            }
            set {
                this.materialCodeIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object periodCost {
            get {
                return this.periodCostField;
            }
            set {
                this.periodCostField = value;
            }
        }
        public object periodPrice {
            get {
                return this.periodPriceField;
            }
            set {
                this.periodPriceField = value;
            }
        }
        public object periodType {
            get {
                return this.periodTypeField;
            }
            set {
                this.periodTypeField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object subscriptionName {
            get {
                return this.subscriptionNameField;
            }
            set {
                this.subscriptionNameField = value;
            }
        }
        public object totalCost {
            get {
                return this.totalCostField;
            }
            set {
                this.totalCostField = value;
            }
        }
        public object totalPrice {
            get {
                return this.totalPriceField;
            }
            set {
                this.totalPriceField = value;
            }
        }
        public object vendorID {
            get {
                return this.vendorIDField;
            }
            set {
                this.vendorIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TagAlias {

        private object idField;
        private object aliasField;
        private object tagIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object alias {
            get {
                return this.aliasField;
            }
            set {
                this.aliasField = value;
            }
        }
        public object tagID {
            get {
                return this.tagIDField;
            }
            set {
                this.tagIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TagGroup {

        private object idField;
        private object displayColorField;
        private object isActiveField;
        private object isSystemField;
        private object labelField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object displayColor {
            get {
                return this.displayColorField;
            }
            set {
                this.displayColorField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isSystem {
            get {
                return this.isSystemField;
            }
            set {
                this.isSystemField = value;
            }
        }
        public object label {
            get {
                return this.labelField;
            }
            set {
                this.labelField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Tag {

        private object idField;
        private object createDateTimeField;
        private object isActiveField;
        private object isExcludedFromAutomaticTaggingField;
        private object isSystemField;
        private object labelField;
        private object lastModifiedDateTimeField;
        private object tagGroupIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isExcludedFromAutomaticTagging {
            get {
                return this.isExcludedFromAutomaticTaggingField;
            }
            set {
                this.isExcludedFromAutomaticTaggingField = value;
            }
        }
        public object isSystem {
            get {
                return this.isSystemField;
            }
            set {
                this.isSystemField = value;
            }
        }
        public object label {
            get {
                return this.labelField;
            }
            set {
                this.labelField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object tagGroupID {
            get {
                return this.tagGroupIDField;
            }
            set {
                this.tagGroupIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TaskAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object publishField;
        private object taskIDField;
        private object taskNoteIDField;
        private object timeEntryIDField;
        private object titleField;
        private object dataField;
        private object isTaskAttachmentField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object taskNoteID {
            get {
                return this.taskNoteIDField;
            }
            set {
                this.taskNoteIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }

    }

    public class TaskNoteAttachment {

        private object idField;
        private object isTaskAttachmentField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object taskIDField;
        private object taskNoteIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object taskNoteID {
            get {
                return this.taskNoteIDField;
            }
            set {
                this.taskNoteIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }

    }

    public class TaskNote {

        private object idField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object createdByContactIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastActivityDateField;
        private object noteTypeField;
        private object publishField;
        private object taskIDField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object createdByContactID {
            get {
                return this.createdByContactIDField;
            }
            set {
                this.createdByContactIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object noteType {
            get {
                return this.noteTypeField;
            }
            set {
                this.noteTypeField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TaskPredecessor {

        private object idField;
        private object lagDaysField;
        private object predecessorTaskIDField;
        private object successorTaskIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object lagDays {
            get {
                return this.lagDaysField;
            }
            set {
                this.lagDaysField = value;
            }
        }
        public object predecessorTaskID {
            get {
                return this.predecessorTaskIDField;
            }
            set {
                this.predecessorTaskIDField = value;
            }
        }
        public object successorTaskID {
            get {
                return this.successorTaskIDField;
            }
            set {
                this.successorTaskIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Task {

        private object idField;
        private object assignedResourceIDField;
        private object assignedResourceRoleIDField;
        private object billingCodeIDField;
        private object canClientPortalUserCompleteTaskField;
        private object companyLocationIDField;
        private object completedByResourceIDField;
        private object completedByTypeField;
        private object completedDateTimeField;
        private object createDateTimeField;
        private object creatorResourceIDField;
        private object creatorTypeField;
        private object departmentIDField;
        private object descriptionField;
        private object endDateTimeField;
        private object estimatedHoursField;
        private object externalIDField;
        private object hoursToBeScheduledField;
        private object isTaskBillableField;
        private object isVisibleInClientPortalField;
        private object lastActivityDateTimeField;
        private object lastActivityPersonTypeField;
        private object lastActivityResourceIDField;
        private object phaseIDField;
        private object priorityField;
        private object priorityLabelField;
        private object projectIDField;
        private object purchaseOrderNumberField;
        private object remainingHoursField;
        private object startDateTimeField;
        private object statusField;
        private object taskCategoryIDField;
        private object taskNumberField;
        private object taskTypeField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object assignedResourceID {
            get {
                return this.assignedResourceIDField;
            }
            set {
                this.assignedResourceIDField = value;
            }
        }
        public object assignedResourceRoleID {
            get {
                return this.assignedResourceRoleIDField;
            }
            set {
                this.assignedResourceRoleIDField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object canClientPortalUserCompleteTask {
            get {
                return this.canClientPortalUserCompleteTaskField;
            }
            set {
                this.canClientPortalUserCompleteTaskField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object completedByResourceID {
            get {
                return this.completedByResourceIDField;
            }
            set {
                this.completedByResourceIDField = value;
            }
        }
        public object completedByType {
            get {
                return this.completedByTypeField;
            }
            set {
                this.completedByTypeField = value;
            }
        }
        public object completedDateTime {
            get {
                return this.completedDateTimeField;
            }
            set {
                this.completedDateTimeField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object departmentID {
            get {
                return this.departmentIDField;
            }
            set {
                this.departmentIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object estimatedHours {
            get {
                return this.estimatedHoursField;
            }
            set {
                this.estimatedHoursField = value;
            }
        }
        public object externalID {
            get {
                return this.externalIDField;
            }
            set {
                this.externalIDField = value;
            }
        }
        public object hoursToBeScheduled {
            get {
                return this.hoursToBeScheduledField;
            }
            set {
                this.hoursToBeScheduledField = value;
            }
        }
        public object isTaskBillable {
            get {
                return this.isTaskBillableField;
            }
            set {
                this.isTaskBillableField = value;
            }
        }
        public object isVisibleInClientPortal {
            get {
                return this.isVisibleInClientPortalField;
            }
            set {
                this.isVisibleInClientPortalField = value;
            }
        }
        public object lastActivityDateTime {
            get {
                return this.lastActivityDateTimeField;
            }
            set {
                this.lastActivityDateTimeField = value;
            }
        }
        public object lastActivityPersonType {
            get {
                return this.lastActivityPersonTypeField;
            }
            set {
                this.lastActivityPersonTypeField = value;
            }
        }
        public object lastActivityResourceID {
            get {
                return this.lastActivityResourceIDField;
            }
            set {
                this.lastActivityResourceIDField = value;
            }
        }
        public object phaseID {
            get {
                return this.phaseIDField;
            }
            set {
                this.phaseIDField = value;
            }
        }
        public object priority {
            get {
                return this.priorityField;
            }
            set {
                this.priorityField = value;
            }
        }
        public object priorityLabel {
            get {
                return this.priorityLabelField;
            }
            set {
                this.priorityLabelField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object remainingHours {
            get {
                return this.remainingHoursField;
            }
            set {
                this.remainingHoursField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object taskCategoryID {
            get {
                return this.taskCategoryIDField;
            }
            set {
                this.taskCategoryIDField = value;
            }
        }
        public object taskNumber {
            get {
                return this.taskNumberField;
            }
            set {
                this.taskNumberField = value;
            }
        }
        public object taskType {
            get {
                return this.taskTypeField;
            }
            set {
                this.taskTypeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TaskSecondaryResource {

        private object idField;
        private object resourceIDField;
        private object roleIDField;
        private object taskIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TaxCategory {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Tax {

        private object idField;
        private object isCompoundedField;
        private object taxCategoryIDField;
        private object taxNameField;
        private object taxRateField;
        private object taxRegionIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isCompounded {
            get {
                return this.isCompoundedField;
            }
            set {
                this.isCompoundedField = value;
            }
        }
        public object taxCategoryID {
            get {
                return this.taxCategoryIDField;
            }
            set {
                this.taxCategoryIDField = value;
            }
        }
        public object taxName {
            get {
                return this.taxNameField;
            }
            set {
                this.taxNameField = value;
            }
        }
        public object taxRate {
            get {
                return this.taxRateField;
            }
            set {
                this.taxRateField = value;
            }
        }
        public object taxRegionID {
            get {
                return this.taxRegionIDField;
            }
            set {
                this.taxRegionIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TaxRegion {

        private object idField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketAdditionalConfigurationItem {

        private object idField;
        private object configurationItemIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketAdditionalContact {

        private object idField;
        private object contactIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object publishField;
        private object ticketIDField;
        private object ticketNoteIDField;
        private object timeEntryIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object ticketNoteID {
            get {
                return this.ticketNoteIDField;
            }
            set {
                this.ticketNoteIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class TicketCategory {

        private object idField;
        private object displayColorRGBField;
        private object isActiveField;
        private object isApiOnlyField;
        private object isGlobalDefaultField;
        private object nameField;
        private object nicknameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object displayColorRGB {
            get {
                return this.displayColorRGBField;
            }
            set {
                this.displayColorRGBField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isApiOnly {
            get {
                return this.isApiOnlyField;
            }
            set {
                this.isApiOnlyField = value;
            }
        }
        public object isGlobalDefault {
            get {
                return this.isGlobalDefaultField;
            }
            set {
                this.isGlobalDefaultField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object nickname {
            get {
                return this.nicknameField;
            }
            set {
                this.nicknameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketChangeRequestApproval {

        private object idField;
        private object approveRejectDateTimeField;
        private object approveRejectNoteField;
        private object contactIDField;
        private object isApprovedField;
        private object resourceIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object approveRejectDateTime {
            get {
                return this.approveRejectDateTimeField;
            }
            set {
                this.approveRejectDateTimeField = value;
            }
        }
        public object approveRejectNote {
            get {
                return this.approveRejectNoteField;
            }
            set {
                this.approveRejectNoteField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object isApproved {
            get {
                return this.isApprovedField;
            }
            set {
                this.isApprovedField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketCharge {

        private object idField;
        private object billableAmountField;
        private object billingCodeIDField;
        private object chargeTypeField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object creatorResourceIDField;
        private object datePurchasedField;
        private object descriptionField;
        private object extendedCostField;
        private object internalCurrencyBillableAmountField;
        private object internalCurrencyUnitPriceField;
        private object internalPurchaseOrderNumberField;
        private object isBillableToCompanyField;
        private object isBilledField;
        private object nameField;
        private object notesField;
        private object organizationalLevelAssociationIDField;
        private object productIDField;
        private object purchaseOrderNumberField;
        private object statusField;
        private object statusLastModifiedByField;
        private object statusLastModifiedDateField;
        private object ticketIDField;
        private object unitCostField;
        private object unitPriceField;
        private object unitQuantityField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billableAmount {
            get {
                return this.billableAmountField;
            }
            set {
                this.billableAmountField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object chargeType {
            get {
                return this.chargeTypeField;
            }
            set {
                this.chargeTypeField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object datePurchased {
            get {
                return this.datePurchasedField;
            }
            set {
                this.datePurchasedField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object extendedCost {
            get {
                return this.extendedCostField;
            }
            set {
                this.extendedCostField = value;
            }
        }
        public object internalCurrencyBillableAmount {
            get {
                return this.internalCurrencyBillableAmountField;
            }
            set {
                this.internalCurrencyBillableAmountField = value;
            }
        }
        public object internalCurrencyUnitPrice {
            get {
                return this.internalCurrencyUnitPriceField;
            }
            set {
                this.internalCurrencyUnitPriceField = value;
            }
        }
        public object internalPurchaseOrderNumber {
            get {
                return this.internalPurchaseOrderNumberField;
            }
            set {
                this.internalPurchaseOrderNumberField = value;
            }
        }
        public object isBillableToCompany {
            get {
                return this.isBillableToCompanyField;
            }
            set {
                this.isBillableToCompanyField = value;
            }
        }
        public object isBilled {
            get {
                return this.isBilledField;
            }
            set {
                this.isBilledField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object notes {
            get {
                return this.notesField;
            }
            set {
                this.notesField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object productID {
            get {
                return this.productIDField;
            }
            set {
                this.productIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object statusLastModifiedBy {
            get {
                return this.statusLastModifiedByField;
            }
            set {
                this.statusLastModifiedByField = value;
            }
        }
        public object statusLastModifiedDate {
            get {
                return this.statusLastModifiedDateField;
            }
            set {
                this.statusLastModifiedDateField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object unitQuantity {
            get {
                return this.unitQuantityField;
            }
            set {
                this.unitQuantityField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketChecklistItem {

        private object idField;
        private object completedByResourceIDField;
        private object completedDateTimeField;
        private object isCompletedField;
        private object isImportantField;
        private object itemNameField;
        private object knowledgebaseArticleIDField;
        private object positionField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object completedByResourceID {
            get {
                return this.completedByResourceIDField;
            }
            set {
                this.completedByResourceIDField = value;
            }
        }
        public object completedDateTime {
            get {
                return this.completedDateTimeField;
            }
            set {
                this.completedDateTimeField = value;
            }
        }
        public object isCompleted {
            get {
                return this.isCompletedField;
            }
            set {
                this.isCompletedField = value;
            }
        }
        public object isImportant {
            get {
                return this.isImportantField;
            }
            set {
                this.isImportantField = value;
            }
        }
        public object itemName {
            get {
                return this.itemNameField;
            }
            set {
                this.itemNameField = value;
            }
        }
        public object knowledgebaseArticleID {
            get {
                return this.knowledgebaseArticleIDField;
            }
            set {
                this.knowledgebaseArticleIDField = value;
            }
        }
        public object position {
            get {
                return this.positionField;
            }
            set {
                this.positionField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketChecklistLibrary {

        private object idField;
        private object checklistLibraryIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object checklistLibraryID {
            get {
                return this.checklistLibraryIDField;
            }
            set {
                this.checklistLibraryIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketNoteAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object ticketIDField;
        private object ticketNoteIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object ticketNoteID {
            get {
                return this.ticketNoteIDField;
            }
            set {
                this.ticketNoteIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class TicketNote {

        private object idField;
        private object createDateTimeField;
        private object createdByContactIDField;
        private object creatorResourceIDField;
        private object descriptionField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object lastActivityDateField;
        private object noteTypeField;
        private object publishField;
        private object ticketIDField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object createdByContactID {
            get {
                return this.createdByContactIDField;
            }
            set {
                this.createdByContactIDField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object noteType {
            get {
                return this.noteTypeField;
            }
            set {
                this.noteTypeField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketRmaCredit {

        private object idField;
        private object creditAmountField;
        private object creditDetailsField;
        private object internalCurrencyCreditAmountField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object creditAmount {
            get {
                return this.creditAmountField;
            }
            set {
                this.creditAmountField = value;
            }
        }
        public object creditDetails {
            get {
                return this.creditDetailsField;
            }
            set {
                this.creditDetailsField = value;
            }
        }
        public object internalCurrencyCreditAmount {
            get {
                return this.internalCurrencyCreditAmountField;
            }
            set {
                this.internalCurrencyCreditAmountField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Ticket {

        private object idField;
        private object apiVendorIDField;
        private object assignedResourceIDField;
        private object assignedResourceRoleIDField;
        private object billingCodeIDField;
        private object changeApprovalBoardField;
        private object changeApprovalStatusField;
        private object changeApprovalTypeField;
        private object changeInfoField1Field;
        private object changeInfoField2Field;
        private object changeInfoField3Field;
        private object changeInfoField4Field;
        private object changeInfoField5Field;
        private object companyIDField;
        private object companyLocationIDField;
        private object completedByResourceIDField;
        private object completedDateField;
        private object configurationItemIDField;
        private object contactIDField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateField;
        private object createdByContactIDField;
        private object creatorResourceIDField;
        private object creatorTypeField;
        private object currentServiceThermometerRatingField;
        private object descriptionField;
        private object dueDateTimeField;
        private object estimatedHoursField;
        private object externalIDField;
        private object firstResponseAssignedResourceIDField;
        private object firstResponseDateTimeField;
        private object firstResponseDueDateTimeField;
        private object firstResponseInitiatingResourceIDField;
        private object hoursToBeScheduledField;
        private object impersonatorCreatorResourceIDField;
        private object issueTypeField;
        private object lastActivityDateField;
        private object lastActivityPersonTypeField;
        private object lastActivityResourceIDField;
        private object lastCustomerNotificationDateTimeField;
        private object lastCustomerVisibleActivityDateTimeField;
        private object lastTrackedModificationDateTimeField;
        private object monitorIDField;
        private object monitorTypeIDField;
        private object opportunityIDField;
        private object organizationalLevelAssociationIDField;
        private object previousServiceThermometerRatingField;
        private object priorityField;
        private object problemTicketIdField;
        private object projectIDField;
        private object purchaseOrderNumberField;
        private object queueIDField;
        private object resolutionField;
        private object resolutionPlanDateTimeField;
        private object resolutionPlanDueDateTimeField;
        private object resolvedDateTimeField;
        private object resolvedDueDateTimeField;
        private object rmaStatusField;
        private object rmaTypeField;
        private object rmmAlertIDField;
        private object serviceLevelAgreementHasBeenMetField;
        private object serviceLevelAgreementIDField;
        private object serviceLevelAgreementPausedNextEventHoursField;
        private object serviceThermometerTemperatureField;
        private object sourceField;
        private object statusField;
        private object subIssueTypeField;
        private object ticketCategoryField;
        private object ticketNumberField;
        private object ticketTypeField;
        private object titleField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object apiVendorID {
            get {
                return this.apiVendorIDField;
            }
            set {
                this.apiVendorIDField = value;
            }
        }
        public object assignedResourceID {
            get {
                return this.assignedResourceIDField;
            }
            set {
                this.assignedResourceIDField = value;
            }
        }
        public object assignedResourceRoleID {
            get {
                return this.assignedResourceRoleIDField;
            }
            set {
                this.assignedResourceRoleIDField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object changeApprovalBoard {
            get {
                return this.changeApprovalBoardField;
            }
            set {
                this.changeApprovalBoardField = value;
            }
        }
        public object changeApprovalStatus {
            get {
                return this.changeApprovalStatusField;
            }
            set {
                this.changeApprovalStatusField = value;
            }
        }
        public object changeApprovalType {
            get {
                return this.changeApprovalTypeField;
            }
            set {
                this.changeApprovalTypeField = value;
            }
        }
        public object changeInfoField1 {
            get {
                return this.changeInfoField1Field;
            }
            set {
                this.changeInfoField1Field = value;
            }
        }
        public object changeInfoField2 {
            get {
                return this.changeInfoField2Field;
            }
            set {
                this.changeInfoField2Field = value;
            }
        }
        public object changeInfoField3 {
            get {
                return this.changeInfoField3Field;
            }
            set {
                this.changeInfoField3Field = value;
            }
        }
        public object changeInfoField4 {
            get {
                return this.changeInfoField4Field;
            }
            set {
                this.changeInfoField4Field = value;
            }
        }
        public object changeInfoField5 {
            get {
                return this.changeInfoField5Field;
            }
            set {
                this.changeInfoField5Field = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyLocationID {
            get {
                return this.companyLocationIDField;
            }
            set {
                this.companyLocationIDField = value;
            }
        }
        public object completedByResourceID {
            get {
                return this.completedByResourceIDField;
            }
            set {
                this.completedByResourceIDField = value;
            }
        }
        public object completedDate {
            get {
                return this.completedDateField;
            }
            set {
                this.completedDateField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object createdByContactID {
            get {
                return this.createdByContactIDField;
            }
            set {
                this.createdByContactIDField = value;
            }
        }
        public object creatorResourceID {
            get {
                return this.creatorResourceIDField;
            }
            set {
                this.creatorResourceIDField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object currentServiceThermometerRating {
            get {
                return this.currentServiceThermometerRatingField;
            }
            set {
                this.currentServiceThermometerRatingField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object dueDateTime {
            get {
                return this.dueDateTimeField;
            }
            set {
                this.dueDateTimeField = value;
            }
        }
        public object estimatedHours {
            get {
                return this.estimatedHoursField;
            }
            set {
                this.estimatedHoursField = value;
            }
        }
        public object externalID {
            get {
                return this.externalIDField;
            }
            set {
                this.externalIDField = value;
            }
        }
        public object firstResponseAssignedResourceID {
            get {
                return this.firstResponseAssignedResourceIDField;
            }
            set {
                this.firstResponseAssignedResourceIDField = value;
            }
        }
        public object firstResponseDateTime {
            get {
                return this.firstResponseDateTimeField;
            }
            set {
                this.firstResponseDateTimeField = value;
            }
        }
        public object firstResponseDueDateTime {
            get {
                return this.firstResponseDueDateTimeField;
            }
            set {
                this.firstResponseDueDateTimeField = value;
            }
        }
        public object firstResponseInitiatingResourceID {
            get {
                return this.firstResponseInitiatingResourceIDField;
            }
            set {
                this.firstResponseInitiatingResourceIDField = value;
            }
        }
        public object hoursToBeScheduled {
            get {
                return this.hoursToBeScheduledField;
            }
            set {
                this.hoursToBeScheduledField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object issueType {
            get {
                return this.issueTypeField;
            }
            set {
                this.issueTypeField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object lastActivityPersonType {
            get {
                return this.lastActivityPersonTypeField;
            }
            set {
                this.lastActivityPersonTypeField = value;
            }
        }
        public object lastActivityResourceID {
            get {
                return this.lastActivityResourceIDField;
            }
            set {
                this.lastActivityResourceIDField = value;
            }
        }
        public object lastCustomerNotificationDateTime {
            get {
                return this.lastCustomerNotificationDateTimeField;
            }
            set {
                this.lastCustomerNotificationDateTimeField = value;
            }
        }
        public object lastCustomerVisibleActivityDateTime {
            get {
                return this.lastCustomerVisibleActivityDateTimeField;
            }
            set {
                this.lastCustomerVisibleActivityDateTimeField = value;
            }
        }
        public object lastTrackedModificationDateTime {
            get {
                return this.lastTrackedModificationDateTimeField;
            }
            set {
                this.lastTrackedModificationDateTimeField = value;
            }
        }
        public object monitorID {
            get {
                return this.monitorIDField;
            }
            set {
                this.monitorIDField = value;
            }
        }
        public object monitorTypeID {
            get {
                return this.monitorTypeIDField;
            }
            set {
                this.monitorTypeIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object previousServiceThermometerRating {
            get {
                return this.previousServiceThermometerRatingField;
            }
            set {
                this.previousServiceThermometerRatingField = value;
            }
        }
        public object priority {
            get {
                return this.priorityField;
            }
            set {
                this.priorityField = value;
            }
        }
        public object problemTicketId {
            get {
                return this.problemTicketIdField;
            }
            set {
                this.problemTicketIdField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object queueID {
            get {
                return this.queueIDField;
            }
            set {
                this.queueIDField = value;
            }
        }
        public object resolution {
            get {
                return this.resolutionField;
            }
            set {
                this.resolutionField = value;
            }
        }
        public object resolutionPlanDateTime {
            get {
                return this.resolutionPlanDateTimeField;
            }
            set {
                this.resolutionPlanDateTimeField = value;
            }
        }
        public object resolutionPlanDueDateTime {
            get {
                return this.resolutionPlanDueDateTimeField;
            }
            set {
                this.resolutionPlanDueDateTimeField = value;
            }
        }
        public object resolvedDateTime {
            get {
                return this.resolvedDateTimeField;
            }
            set {
                this.resolvedDateTimeField = value;
            }
        }
        public object resolvedDueDateTime {
            get {
                return this.resolvedDueDateTimeField;
            }
            set {
                this.resolvedDueDateTimeField = value;
            }
        }
        public object rmaStatus {
            get {
                return this.rmaStatusField;
            }
            set {
                this.rmaStatusField = value;
            }
        }
        public object rmaType {
            get {
                return this.rmaTypeField;
            }
            set {
                this.rmaTypeField = value;
            }
        }
        public object rmmAlertID {
            get {
                return this.rmmAlertIDField;
            }
            set {
                this.rmmAlertIDField = value;
            }
        }
        public object serviceLevelAgreementHasBeenMet {
            get {
                return this.serviceLevelAgreementHasBeenMetField;
            }
            set {
                this.serviceLevelAgreementHasBeenMetField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object serviceLevelAgreementPausedNextEventHours {
            get {
                return this.serviceLevelAgreementPausedNextEventHoursField;
            }
            set {
                this.serviceLevelAgreementPausedNextEventHoursField = value;
            }
        }
        public object serviceThermometerTemperature {
            get {
                return this.serviceThermometerTemperatureField;
            }
            set {
                this.serviceThermometerTemperatureField = value;
            }
        }
        public object source {
            get {
                return this.sourceField;
            }
            set {
                this.sourceField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object subIssueType {
            get {
                return this.subIssueTypeField;
            }
            set {
                this.subIssueTypeField = value;
            }
        }
        public object ticketCategory {
            get {
                return this.ticketCategoryField;
            }
            set {
                this.ticketCategoryField = value;
            }
        }
        public object ticketNumber {
            get {
                return this.ticketNumberField;
            }
            set {
                this.ticketNumberField = value;
            }
        }
        public object ticketType {
            get {
                return this.ticketTypeField;
            }
            set {
                this.ticketTypeField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketSecondaryResource {

        private object idField;
        private object resourceIDField;
        private object roleIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketTagAssociation {

        private object idField;
        private object tagIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object tagID {
            get {
                return this.tagIDField;
            }
            set {
                this.tagIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TimeEntry {

        private object idField;
        private object billingApprovalDateTimeField;
        private object billingApprovalLevelMostRecentField;
        private object billingApprovalResourceIDField;
        private object billingCodeIDField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object contractServiceIDField;
        private object createDateTimeField;
        private object creatorUserIDField;
        private object dateWorkedField;
        private object endDateTimeField;
        private object hoursToBillField;
        private object hoursWorkedField;
        private object impersonatorCreatorResourceIDField;
        private object impersonatorUpdaterResourceIDField;
        private object internalBillingCodeIDField;
        private object internalNotesField;
        private object isNonBillableField;
        private object lastModifiedDateTimeField;
        private object lastModifiedUserIDField;
        private object offsetHoursField;
        private object resourceIDField;
        private object roleIDField;
        private object showOnInvoiceField;
        private object startDateTimeField;
        private object summaryNotesField;
        private object taskIDField;
        private object ticketIDField;
        private object timeEntryTypeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingApprovalDateTime {
            get {
                return this.billingApprovalDateTimeField;
            }
            set {
                this.billingApprovalDateTimeField = value;
            }
        }
        public object billingApprovalLevelMostRecent {
            get {
                return this.billingApprovalLevelMostRecentField;
            }
            set {
                this.billingApprovalLevelMostRecentField = value;
            }
        }
        public object billingApprovalResourceID {
            get {
                return this.billingApprovalResourceIDField;
            }
            set {
                this.billingApprovalResourceIDField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object creatorUserID {
            get {
                return this.creatorUserIDField;
            }
            set {
                this.creatorUserIDField = value;
            }
        }
        public object dateWorked {
            get {
                return this.dateWorkedField;
            }
            set {
                this.dateWorkedField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object hoursToBill {
            get {
                return this.hoursToBillField;
            }
            set {
                this.hoursToBillField = value;
            }
        }
        public object hoursWorked {
            get {
                return this.hoursWorkedField;
            }
            set {
                this.hoursWorkedField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object impersonatorUpdaterResourceID {
            get {
                return this.impersonatorUpdaterResourceIDField;
            }
            set {
                this.impersonatorUpdaterResourceIDField = value;
            }
        }
        public object internalBillingCodeID {
            get {
                return this.internalBillingCodeIDField;
            }
            set {
                this.internalBillingCodeIDField = value;
            }
        }
        public object internalNotes {
            get {
                return this.internalNotesField;
            }
            set {
                this.internalNotesField = value;
            }
        }
        public object isNonBillable {
            get {
                return this.isNonBillableField;
            }
            set {
                this.isNonBillableField = value;
            }
        }
        public object lastModifiedDateTime {
            get {
                return this.lastModifiedDateTimeField;
            }
            set {
                this.lastModifiedDateTimeField = value;
            }
        }
        public object lastModifiedUserID {
            get {
                return this.lastModifiedUserIDField;
            }
            set {
                this.lastModifiedUserIDField = value;
            }
        }
        public object offsetHours {
            get {
                return this.offsetHoursField;
            }
            set {
                this.offsetHoursField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object showOnInvoice {
            get {
                return this.showOnInvoiceField;
            }
            set {
                this.showOnInvoiceField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object summaryNotes {
            get {
                return this.summaryNotesField;
            }
            set {
                this.summaryNotesField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object timeEntryType {
            get {
                return this.timeEntryTypeField;
            }
            set {
                this.timeEntryTypeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TimeEntryAttachment {

        private object idField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object contentTypeField;
        private object creatorTypeField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentIDField;
        private object publishField;
        private object taskIDField;
        private object ticketIDField;
        private object timeEntryIDField;
        private object titleField;
        private object dataField;
        private object parentTypeField;
        private object soapParentPropertyIdField;
        private object isTaskAttachmentField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object isTaskAttachment {
            get {
                return this.isTaskAttachmentField;
            }
            set {
                this.isTaskAttachmentField = value;
            }
        }

    }

    public class UserDefinedFieldDefinition {

        private object idField;
        private object createDateField;
        private object crmToProjectUdfIdField;
        private object dataTypeField;
        private object defaultValueField;
        private object descriptionField;
        private object displayFormatField;
        private object isActiveField;
        private object isEncryptedField;
        private object isFieldMappingField;
        private object isPrivateField;
        private object isProtectedField;
        private object isRequiredField;
        private object isVisibleToClientPortalField;
        private object mergeVariableNameField;
        private object nameField;
        private object numberOfDecimalPlacesField;
        private object sortOrderField;
        private object udfTypeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object crmToProjectUdfId {
            get {
                return this.crmToProjectUdfIdField;
            }
            set {
                this.crmToProjectUdfIdField = value;
            }
        }
        public object dataType {
            get {
                return this.dataTypeField;
            }
            set {
                this.dataTypeField = value;
            }
        }
        public object defaultValue {
            get {
                return this.defaultValueField;
            }
            set {
                this.defaultValueField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object displayFormat {
            get {
                return this.displayFormatField;
            }
            set {
                this.displayFormatField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isEncrypted {
            get {
                return this.isEncryptedField;
            }
            set {
                this.isEncryptedField = value;
            }
        }
        public object isFieldMapping {
            get {
                return this.isFieldMappingField;
            }
            set {
                this.isFieldMappingField = value;
            }
        }
        public object isPrivate {
            get {
                return this.isPrivateField;
            }
            set {
                this.isPrivateField = value;
            }
        }
        public object isProtected {
            get {
                return this.isProtectedField;
            }
            set {
                this.isProtectedField = value;
            }
        }
        public object isRequired {
            get {
                return this.isRequiredField;
            }
            set {
                this.isRequiredField = value;
            }
        }
        public object isVisibleToClientPortal {
            get {
                return this.isVisibleToClientPortalField;
            }
            set {
                this.isVisibleToClientPortalField = value;
            }
        }
        public object mergeVariableName {
            get {
                return this.mergeVariableNameField;
            }
            set {
                this.mergeVariableNameField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object numberOfDecimalPlaces {
            get {
                return this.numberOfDecimalPlacesField;
            }
            set {
                this.numberOfDecimalPlacesField = value;
            }
        }
        public object sortOrder {
            get {
                return this.sortOrderField;
            }
            set {
                this.sortOrderField = value;
            }
        }
        public object udfType {
            get {
                return this.udfTypeField;
            }
            set {
                this.udfTypeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class UserDefinedFieldListItem {

        private object idField;
        private object createDateField;
        private object isActiveField;
        private object udfFieldIdField;
        private object valueForDisplayField;
        private object valueForExportField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object udfFieldId {
            get {
                return this.udfFieldIdField;
            }
            set {
                this.udfFieldIdField = value;
            }
        }
        public object valueForDisplay {
            get {
                return this.valueForDisplayField;
            }
            set {
                this.valueForDisplayField = value;
            }
        }
        public object valueForExport {
            get {
                return this.valueForExportField;
            }
            set {
                this.valueForExportField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class WorkTypeModifier {

        private object idField;
        private object modifierTypeField;
        private object modifierValueField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object modifierType {
            get {
                return this.modifierTypeField;
            }
            set {
                this.modifierTypeField = value;
            }
        }
        public object modifierValue {
            get {
                return this.modifierValueField;
            }
            set {
                this.modifierValueField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Filter {

        private object opField;
        private object fieldField;
        private object udfField;
        private object valueField;
        private object itemsField;
  

        public object op {
            get {
                return this.opField;
            }
            set {
                this.opField = value;
            }
        }
        public object field {
            get {
                return this.fieldField;
            }
            set {
                this.fieldField = value;
            }
        }
        public object udf {
            get {
                return this.udfField;
            }
            set {
                this.udfField = value;
            }
        }
        public object value {
            get {
                return this.valueField;
            }
            set {
                this.valueField = value;
            }
        }
        public object items {
            get {
                return this.itemsField;
            }
            set {
                this.itemsField = value;
            }
        }

    }

    public class ValueItem {

        private object elementListField;
        private object boolValueField;
        private object longValueField;
        private object stringValueField;
  

        public object elementList {
            get {
                return this.elementListField;
            }
            set {
                this.elementListField = value;
            }
        }
        public object boolValue {
            get {
                return this.boolValueField;
            }
            set {
                this.boolValueField = value;
            }
        }
        public object longValue {
            get {
                return this.longValueField;
            }
            set {
                this.longValueField = value;
            }
        }
        public object stringValue {
            get {
                return this.stringValueField;
            }
            set {
                this.stringValueField = value;
            }
        }

    }

    public class CollectionItem {

        private object longValueField;
        private object stringValueField;
  

        public object longValue {
            get {
                return this.longValueField;
            }
            set {
                this.longValueField = value;
            }
        }
        public object stringValue {
            get {
                return this.stringValueField;
            }
            set {
                this.stringValueField = value;
            }
        }

    }

    public class Paging {

        private object countField;
        private object requestCountField;
        private object prevPageUrlField;
        private object nextPageUrlField;
  

        public object count {
            get {
                return this.countField;
            }
            set {
                this.countField = value;
            }
        }
        public object requestCount {
            get {
                return this.requestCountField;
            }
            set {
                this.requestCountField = value;
            }
        }
        public object prevPageUrl {
            get {
                return this.prevPageUrlField;
            }
            set {
                this.prevPageUrlField = value;
            }
        }
        public object nextPageUrl {
            get {
                return this.nextPageUrlField;
            }
            set {
                this.nextPageUrlField = value;
            }
        }

    }

    public class AdditionalInvoiceFieldValue {

        private object idField;
        private object additionalInvoiceFieldIDField;
        private object fieldValueField;
        private object invoiceBatchIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalInvoiceFieldID {
            get {
                return this.additionalInvoiceFieldIDField;
            }
            set {
                this.additionalInvoiceFieldIDField = value;
            }
        }
        public object fieldValue {
            get {
                return this.fieldValueField;
            }
            set {
                this.fieldValueField = value;
            }
        }
        public object invoiceBatchID {
            get {
                return this.invoiceBatchIDField;
            }
            set {
                this.invoiceBatchIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class AttachmentInfo {

        private object idField;
        private object articleIDField;
        private object attachDateField;
        private object attachedByContactIDField;
        private object attachedByResourceIDField;
        private object attachmentTypeField;
        private object companyIDField;
        private object companyNoteIDField;
        private object configurationItemIDField;
        private object configurationItemNoteIDField;
        private object contentTypeField;
        private object contractIDField;
        private object contractNoteIDField;
        private object creatorTypeField;
        private object documentIDField;
        private object expenseReportIDField;
        private object fileSizeField;
        private object fullPathField;
        private object impersonatorCreatorResourceIDField;
        private object opportunityIDField;
        private object parentAttachmentIDField;
        private object parentIDField;
        private object parentTypeField;
        private object projectIDField;
        private object projectNoteIDField;
        private object publishField;
        private object resourceIDField;
        private object salesOrderIDField;
        private object taskIDField;
        private object taskNoteIDField;
        private object ticketIDField;
        private object ticketNoteIDField;
        private object timeEntryIDField;
        private object titleField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object articleID {
            get {
                return this.articleIDField;
            }
            set {
                this.articleIDField = value;
            }
        }
        public object attachDate {
            get {
                return this.attachDateField;
            }
            set {
                this.attachDateField = value;
            }
        }
        public object attachedByContactID {
            get {
                return this.attachedByContactIDField;
            }
            set {
                this.attachedByContactIDField = value;
            }
        }
        public object attachedByResourceID {
            get {
                return this.attachedByResourceIDField;
            }
            set {
                this.attachedByResourceIDField = value;
            }
        }
        public object attachmentType {
            get {
                return this.attachmentTypeField;
            }
            set {
                this.attachmentTypeField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyNoteID {
            get {
                return this.companyNoteIDField;
            }
            set {
                this.companyNoteIDField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object configurationItemNoteID {
            get {
                return this.configurationItemNoteIDField;
            }
            set {
                this.configurationItemNoteIDField = value;
            }
        }
        public object contentType {
            get {
                return this.contentTypeField;
            }
            set {
                this.contentTypeField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractNoteID {
            get {
                return this.contractNoteIDField;
            }
            set {
                this.contractNoteIDField = value;
            }
        }
        public object creatorType {
            get {
                return this.creatorTypeField;
            }
            set {
                this.creatorTypeField = value;
            }
        }
        public object documentID {
            get {
                return this.documentIDField;
            }
            set {
                this.documentIDField = value;
            }
        }
        public object expenseReportID {
            get {
                return this.expenseReportIDField;
            }
            set {
                this.expenseReportIDField = value;
            }
        }
        public object fileSize {
            get {
                return this.fileSizeField;
            }
            set {
                this.fileSizeField = value;
            }
        }
        public object fullPath {
            get {
                return this.fullPathField;
            }
            set {
                this.fullPathField = value;
            }
        }
        public object impersonatorCreatorResourceID {
            get {
                return this.impersonatorCreatorResourceIDField;
            }
            set {
                this.impersonatorCreatorResourceIDField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object parentAttachmentID {
            get {
                return this.parentAttachmentIDField;
            }
            set {
                this.parentAttachmentIDField = value;
            }
        }
        public object parentID {
            get {
                return this.parentIDField;
            }
            set {
                this.parentIDField = value;
            }
        }
        public object parentType {
            get {
                return this.parentTypeField;
            }
            set {
                this.parentTypeField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object projectNoteID {
            get {
                return this.projectNoteIDField;
            }
            set {
                this.projectNoteIDField = value;
            }
        }
        public object publish {
            get {
                return this.publishField;
            }
            set {
                this.publishField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object salesOrderID {
            get {
                return this.salesOrderIDField;
            }
            set {
                this.salesOrderIDField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object taskNoteID {
            get {
                return this.taskNoteIDField;
            }
            set {
                this.taskNoteIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object ticketNoteID {
            get {
                return this.ticketNoteIDField;
            }
            set {
                this.ticketNoteIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class BillingCode {

        private object idField;
        private object afterHoursWorkTypeField;
        private object billingCodeTypeField;
        private object departmentField;
        private object descriptionField;
        private object externalNumberField;
        private object generalLedgerAccountField;
        private object isActiveField;
        private object isExcludedFromNewContractsField;
        private object markupRateField;
        private object nameField;
        private object taxCategoryIDField;
        private object unitCostField;
        private object unitPriceField;
        private object useTypeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object afterHoursWorkType {
            get {
                return this.afterHoursWorkTypeField;
            }
            set {
                this.afterHoursWorkTypeField = value;
            }
        }
        public object billingCodeType {
            get {
                return this.billingCodeTypeField;
            }
            set {
                this.billingCodeTypeField = value;
            }
        }
        public object department {
            get {
                return this.departmentField;
            }
            set {
                this.departmentField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object externalNumber {
            get {
                return this.externalNumberField;
            }
            set {
                this.externalNumberField = value;
            }
        }
        public object generalLedgerAccount {
            get {
                return this.generalLedgerAccountField;
            }
            set {
                this.generalLedgerAccountField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isExcludedFromNewContracts {
            get {
                return this.isExcludedFromNewContractsField;
            }
            set {
                this.isExcludedFromNewContractsField = value;
            }
        }
        public object markupRate {
            get {
                return this.markupRateField;
            }
            set {
                this.markupRateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object taxCategoryID {
            get {
                return this.taxCategoryIDField;
            }
            set {
                this.taxCategoryIDField = value;
            }
        }
        public object unitCost {
            get {
                return this.unitCostField;
            }
            set {
                this.unitCostField = value;
            }
        }
        public object unitPrice {
            get {
                return this.unitPriceField;
            }
            set {
                this.unitPriceField = value;
            }
        }
        public object useType {
            get {
                return this.useTypeField;
            }
            set {
                this.useTypeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ClassificationIcon {

        private object idField;
        private object descriptionField;
        private object isActiveField;
        private object isSystemField;
        private object nameField;
        private object relativeUrlField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isSystem {
            get {
                return this.isSystemField;
            }
            set {
                this.isSystemField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object relativeUrl {
            get {
                return this.relativeUrlField;
            }
            set {
                this.relativeUrlField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemDnsRecord {

        private object idField;
        private object createDateTimeField;
        private object dataField;
        private object installedProductIDField;
        private object timeToLiveSecondsField;
        private object dnsTypeField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object data {
            get {
                return this.dataField;
            }
            set {
                this.dataField = value;
            }
        }
        public object installedProductID {
            get {
                return this.installedProductIDField;
            }
            set {
                this.installedProductIDField = value;
            }
        }
        public object timeToLiveSeconds {
            get {
                return this.timeToLiveSecondsField;
            }
            set {
                this.timeToLiveSecondsField = value;
            }
        }
        public object dnsType {
            get {
                return this.dnsTypeField;
            }
            set {
                this.dnsTypeField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ConfigurationItemSslSubjectAlternativeName {

        private object idField;
        private object configurationItemIDField;
        private object nameField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object configurationItemID {
            get {
                return this.configurationItemIDField;
            }
            set {
                this.configurationItemIDField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractServiceBundleUnit {

        private object idField;
        private object approveAndPostDateField;
        private object contractIDField;
        private object contractServiceBundleIDField;
        private object costField;
        private object endDateField;
        private object internalCurrencyPriceField;
        private object organizationalLevelAssociationIDField;
        private object priceField;
        private object serviceBundleIDField;
        private object startDateField;
        private object unitsField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object approveAndPostDate {
            get {
                return this.approveAndPostDateField;
            }
            set {
                this.approveAndPostDateField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceBundleID {
            get {
                return this.contractServiceBundleIDField;
            }
            set {
                this.contractServiceBundleIDField = value;
            }
        }
        public object cost {
            get {
                return this.costField;
            }
            set {
                this.costField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object internalCurrencyPrice {
            get {
                return this.internalCurrencyPriceField;
            }
            set {
                this.internalCurrencyPriceField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object price {
            get {
                return this.priceField;
            }
            set {
                this.priceField = value;
            }
        }
        public object serviceBundleID {
            get {
                return this.serviceBundleIDField;
            }
            set {
                this.serviceBundleIDField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object units {
            get {
                return this.unitsField;
            }
            set {
                this.unitsField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ContractServiceUnit {

        private object idField;
        private object approveAndPostDateField;
        private object contractIDField;
        private object contractServiceIDField;
        private object costField;
        private object endDateField;
        private object internalCurrencyPriceField;
        private object organizationalLevelAssociationIDField;
        private object priceField;
        private object serviceIDField;
        private object startDateField;
        private object unitsField;
        private object vendorCompanyIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object approveAndPostDate {
            get {
                return this.approveAndPostDateField;
            }
            set {
                this.approveAndPostDateField = value;
            }
        }
        public object contractID {
            get {
                return this.contractIDField;
            }
            set {
                this.contractIDField = value;
            }
        }
        public object contractServiceID {
            get {
                return this.contractServiceIDField;
            }
            set {
                this.contractServiceIDField = value;
            }
        }
        public object cost {
            get {
                return this.costField;
            }
            set {
                this.costField = value;
            }
        }
        public object endDate {
            get {
                return this.endDateField;
            }
            set {
                this.endDateField = value;
            }
        }
        public object internalCurrencyPrice {
            get {
                return this.internalCurrencyPriceField;
            }
            set {
                this.internalCurrencyPriceField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object price {
            get {
                return this.priceField;
            }
            set {
                this.priceField = value;
            }
        }
        public object serviceID {
            get {
                return this.serviceIDField;
            }
            set {
                this.serviceIDField = value;
            }
        }
        public object startDate {
            get {
                return this.startDateField;
            }
            set {
                this.startDateField = value;
            }
        }
        public object units {
            get {
                return this.unitsField;
            }
            set {
                this.unitsField = value;
            }
        }
        public object vendorCompanyID {
            get {
                return this.vendorCompanyIDField;
            }
            set {
                this.vendorCompanyIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DeletedTaskActivityLog {

        private object idField;
        private object typeIDField;
        private object taskIDField;
        private object taskNumberField;
        private object noteOrAttachmentTitleField;
        private object createdByResourceIDField;
        private object activityDateTimeField;
        private object startDateTimeField;
        private object endDateTimeField;
        private object hoursWorkedField;
        private object deletedByResourceIDField;
        private object deletedDateTimeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object typeID {
            get {
                return this.typeIDField;
            }
            set {
                this.typeIDField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object taskNumber {
            get {
                return this.taskNumberField;
            }
            set {
                this.taskNumberField = value;
            }
        }
        public object noteOrAttachmentTitle {
            get {
                return this.noteOrAttachmentTitleField;
            }
            set {
                this.noteOrAttachmentTitleField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object activityDateTime {
            get {
                return this.activityDateTimeField;
            }
            set {
                this.activityDateTimeField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object hoursWorked {
            get {
                return this.hoursWorkedField;
            }
            set {
                this.hoursWorkedField = value;
            }
        }
        public object deletedByResourceID {
            get {
                return this.deletedByResourceIDField;
            }
            set {
                this.deletedByResourceIDField = value;
            }
        }
        public object deletedDateTime {
            get {
                return this.deletedDateTimeField;
            }
            set {
                this.deletedDateTimeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DeletedTicketActivityLog {

        private object idField;
        private object typeIDField;
        private object ticketIDField;
        private object ticketNumberField;
        private object noteOrAttachmentTitleField;
        private object createdByResourceIDField;
        private object activityDateTimeField;
        private object startDateTimeField;
        private object endDateTimeField;
        private object hoursWorkedField;
        private object deletedByResourceIDField;
        private object deletedDateTimeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object typeID {
            get {
                return this.typeIDField;
            }
            set {
                this.typeIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object ticketNumber {
            get {
                return this.ticketNumberField;
            }
            set {
                this.ticketNumberField = value;
            }
        }
        public object noteOrAttachmentTitle {
            get {
                return this.noteOrAttachmentTitleField;
            }
            set {
                this.noteOrAttachmentTitleField = value;
            }
        }
        public object createdByResourceID {
            get {
                return this.createdByResourceIDField;
            }
            set {
                this.createdByResourceIDField = value;
            }
        }
        public object activityDateTime {
            get {
                return this.activityDateTimeField;
            }
            set {
                this.activityDateTimeField = value;
            }
        }
        public object startDateTime {
            get {
                return this.startDateTimeField;
            }
            set {
                this.startDateTimeField = value;
            }
        }
        public object endDateTime {
            get {
                return this.endDateTimeField;
            }
            set {
                this.endDateTimeField = value;
            }
        }
        public object hoursWorked {
            get {
                return this.hoursWorkedField;
            }
            set {
                this.hoursWorkedField = value;
            }
        }
        public object deletedByResourceID {
            get {
                return this.deletedByResourceIDField;
            }
            set {
                this.deletedByResourceIDField = value;
            }
        }
        public object deletedDateTime {
            get {
                return this.deletedDateTimeField;
            }
            set {
                this.deletedDateTimeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class DeletedTicketLog {

        private object idField;
        private object ticketIDField;
        private object ticketNumberField;
        private object ticketTitleField;
        private object deletedByResourceIDField;
        private object deletedDateTimeField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object ticketNumber {
            get {
                return this.ticketNumberField;
            }
            set {
                this.ticketNumberField = value;
            }
        }
        public object ticketTitle {
            get {
                return this.ticketTitleField;
            }
            set {
                this.ticketTitleField = value;
            }
        }
        public object deletedByResourceID {
            get {
                return this.deletedByResourceIDField;
            }
            set {
                this.deletedByResourceIDField = value;
            }
        }
        public object deletedDateTime {
            get {
                return this.deletedDateTimeField;
            }
            set {
                this.deletedDateTimeField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InternalLocation {

        private object idField;
        private object additionalAddressInfoField;
        private object address1Field;
        private object address2Field;
        private object cityField;
        private object countryField;
        private object holidaySetIdField;
        private object isDefaultField;
        private object nameField;
        private object postalCodeField;
        private object stateField;
        private object timeZoneField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object additionalAddressInfo {
            get {
                return this.additionalAddressInfoField;
            }
            set {
                this.additionalAddressInfoField = value;
            }
        }
        public object address1 {
            get {
                return this.address1Field;
            }
            set {
                this.address1Field = value;
            }
        }
        public object address2 {
            get {
                return this.address2Field;
            }
            set {
                this.address2Field = value;
            }
        }
        public object city {
            get {
                return this.cityField;
            }
            set {
                this.cityField = value;
            }
        }
        public object country {
            get {
                return this.countryField;
            }
            set {
                this.countryField = value;
            }
        }
        public object holidaySetId {
            get {
                return this.holidaySetIdField;
            }
            set {
                this.holidaySetIdField = value;
            }
        }
        public object isDefault {
            get {
                return this.isDefaultField;
            }
            set {
                this.isDefaultField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object postalCode {
            get {
                return this.postalCodeField;
            }
            set {
                this.postalCodeField = value;
            }
        }
        public object state {
            get {
                return this.stateField;
            }
            set {
                this.stateField = value;
            }
        }
        public object timeZone {
            get {
                return this.timeZoneField;
            }
            set {
                this.timeZoneField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class InvoiceTemplate {

        private object idField;
        private object coveredByBlockRetainerContractLabelField;
        private object coveredByRecurringServiceFixedPricePerTicketContractLabelField;
        private object currencyNegativeFormatField;
        private object currencyPositiveFormatField;
        private object dateFormatField;
        private object displayFixedPriceContractLaborField;
        private object displayRecurringServiceContractLaborField;
        private object displaySeparateLineItemForEachTaxField;
        private object displayTaxCategoryField;
        private object displayTaxCategorySuperscriptsField;
        private object displayZeroAmountRecurringServicesAndBundlesField;
        private object groupByField;
        private object itemizeItemsInEachGroupField;
        private object itemizeServicesAndBundlesField;
        private object nameField;
        private object nonBillableLaborLabelField;
        private object numberFormatField;
        private object pageLayoutField;
        private object pageNumberFormatField;
        private object paymentTermsField;
        private object rateCostExpressionField;
        private object showGridHeaderField;
        private object showVerticalGridLinesField;
        private object sortByField;
        private object timeFormatField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object coveredByBlockRetainerContractLabel {
            get {
                return this.coveredByBlockRetainerContractLabelField;
            }
            set {
                this.coveredByBlockRetainerContractLabelField = value;
            }
        }
        public object coveredByRecurringServiceFixedPricePerTicketContractLabel {
            get {
                return this.coveredByRecurringServiceFixedPricePerTicketContractLabelField;
            }
            set {
                this.coveredByRecurringServiceFixedPricePerTicketContractLabelField = value;
            }
        }
        public object currencyNegativeFormat {
            get {
                return this.currencyNegativeFormatField;
            }
            set {
                this.currencyNegativeFormatField = value;
            }
        }
        public object currencyPositiveFormat {
            get {
                return this.currencyPositiveFormatField;
            }
            set {
                this.currencyPositiveFormatField = value;
            }
        }
        public object dateFormat {
            get {
                return this.dateFormatField;
            }
            set {
                this.dateFormatField = value;
            }
        }
        public object displayFixedPriceContractLabor {
            get {
                return this.displayFixedPriceContractLaborField;
            }
            set {
                this.displayFixedPriceContractLaborField = value;
            }
        }
        public object displayRecurringServiceContractLabor {
            get {
                return this.displayRecurringServiceContractLaborField;
            }
            set {
                this.displayRecurringServiceContractLaborField = value;
            }
        }
        public object displaySeparateLineItemForEachTax {
            get {
                return this.displaySeparateLineItemForEachTaxField;
            }
            set {
                this.displaySeparateLineItemForEachTaxField = value;
            }
        }
        public object displayTaxCategory {
            get {
                return this.displayTaxCategoryField;
            }
            set {
                this.displayTaxCategoryField = value;
            }
        }
        public object displayTaxCategorySuperscripts {
            get {
                return this.displayTaxCategorySuperscriptsField;
            }
            set {
                this.displayTaxCategorySuperscriptsField = value;
            }
        }
        public object displayZeroAmountRecurringServicesAndBundles {
            get {
                return this.displayZeroAmountRecurringServicesAndBundlesField;
            }
            set {
                this.displayZeroAmountRecurringServicesAndBundlesField = value;
            }
        }
        public object groupBy {
            get {
                return this.groupByField;
            }
            set {
                this.groupByField = value;
            }
        }
        public object itemizeItemsInEachGroup {
            get {
                return this.itemizeItemsInEachGroupField;
            }
            set {
                this.itemizeItemsInEachGroupField = value;
            }
        }
        public object itemizeServicesAndBundles {
            get {
                return this.itemizeServicesAndBundlesField;
            }
            set {
                this.itemizeServicesAndBundlesField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object nonBillableLaborLabel {
            get {
                return this.nonBillableLaborLabelField;
            }
            set {
                this.nonBillableLaborLabelField = value;
            }
        }
        public object numberFormat {
            get {
                return this.numberFormatField;
            }
            set {
                this.numberFormatField = value;
            }
        }
        public object pageLayout {
            get {
                return this.pageLayoutField;
            }
            set {
                this.pageLayoutField = value;
            }
        }
        public object pageNumberFormat {
            get {
                return this.pageNumberFormatField;
            }
            set {
                this.pageNumberFormatField = value;
            }
        }
        public object paymentTerms {
            get {
                return this.paymentTermsField;
            }
            set {
                this.paymentTermsField = value;
            }
        }
        public object rateCostExpression {
            get {
                return this.rateCostExpressionField;
            }
            set {
                this.rateCostExpressionField = value;
            }
        }
        public object showGridHeader {
            get {
                return this.showGridHeaderField;
            }
            set {
                this.showGridHeaderField = value;
            }
        }
        public object showVerticalGridLines {
            get {
                return this.showVerticalGridLinesField;
            }
            set {
                this.showVerticalGridLinesField = value;
            }
        }
        public object sortBy {
            get {
                return this.sortByField;
            }
            set {
                this.sortByField = value;
            }
        }
        public object timeFormat {
            get {
                return this.timeFormatField;
            }
            set {
                this.timeFormatField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class NotificationHistory {

        private object idField;
        private object companyIDField;
        private object entityNumberField;
        private object entityTitleField;
        private object initiatingContactIDField;
        private object initiatingResourceIDField;
        private object isActiveField;
        private object isDeletedField;
        private object isTemplateJobField;
        private object notificationHistoryTypeIDField;
        private object notificationSentTimeField;
        private object opportunityIDField;
        private object projectIDField;
        private object quoteIDField;
        private object recipientDisplayNameField;
        private object recipientEmailAddressField;
        private object taskIDField;
        private object templateNameField;
        private object ticketIDField;
        private object timeEntryIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object entityNumber {
            get {
                return this.entityNumberField;
            }
            set {
                this.entityNumberField = value;
            }
        }
        public object entityTitle {
            get {
                return this.entityTitleField;
            }
            set {
                this.entityTitleField = value;
            }
        }
        public object initiatingContactID {
            get {
                return this.initiatingContactIDField;
            }
            set {
                this.initiatingContactIDField = value;
            }
        }
        public object initiatingResourceID {
            get {
                return this.initiatingResourceIDField;
            }
            set {
                this.initiatingResourceIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isDeleted {
            get {
                return this.isDeletedField;
            }
            set {
                this.isDeletedField = value;
            }
        }
        public object isTemplateJob {
            get {
                return this.isTemplateJobField;
            }
            set {
                this.isTemplateJobField = value;
            }
        }
        public object notificationHistoryTypeID {
            get {
                return this.notificationHistoryTypeIDField;
            }
            set {
                this.notificationHistoryTypeIDField = value;
            }
        }
        public object notificationSentTime {
            get {
                return this.notificationSentTimeField;
            }
            set {
                this.notificationSentTimeField = value;
            }
        }
        public object opportunityID {
            get {
                return this.opportunityIDField;
            }
            set {
                this.opportunityIDField = value;
            }
        }
        public object projectID {
            get {
                return this.projectIDField;
            }
            set {
                this.projectIDField = value;
            }
        }
        public object quoteID {
            get {
                return this.quoteIDField;
            }
            set {
                this.quoteIDField = value;
            }
        }
        public object recipientDisplayName {
            get {
                return this.recipientDisplayNameField;
            }
            set {
                this.recipientDisplayNameField = value;
            }
        }
        public object recipientEmailAddress {
            get {
                return this.recipientEmailAddressField;
            }
            set {
                this.recipientEmailAddressField = value;
            }
        }
        public object taskID {
            get {
                return this.taskIDField;
            }
            set {
                this.taskIDField = value;
            }
        }
        public object templateName {
            get {
                return this.templateNameField;
            }
            set {
                this.templateNameField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object timeEntryID {
            get {
                return this.timeEntryIDField;
            }
            set {
                this.timeEntryIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class OrganizationalResource {

        private object idField;
        private object organizationalLevelAssociationIDField;
        private object resourceIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class QuoteTemplate {

        private object idField;
        private object calculateTaxSeparatelyField;
        private object createDateField;
        private object createdByField;
        private object currencyNegativeFormatField;
        private object currencyPositiveFormatField;
        private object dateFormatField;
        private object descriptionField;
        private object displayTaxCategorySuperscriptsField;
        private object isActiveField;
        private object lastActivityByField;
        private object lastActivityDateField;
        private object nameField;
        private object numberFormatField;
        private object pageLayoutField;
        private object pageNumberFormatField;
        private object showEachTaxInGroupField;
        private object showGridHeaderField;
        private object showTaxCategoryField;
        private object showVerticalGridLinesField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object calculateTaxSeparately {
            get {
                return this.calculateTaxSeparatelyField;
            }
            set {
                this.calculateTaxSeparatelyField = value;
            }
        }
        public object createDate {
            get {
                return this.createDateField;
            }
            set {
                this.createDateField = value;
            }
        }
        public object createdBy {
            get {
                return this.createdByField;
            }
            set {
                this.createdByField = value;
            }
        }
        public object currencyNegativeFormat {
            get {
                return this.currencyNegativeFormatField;
            }
            set {
                this.currencyNegativeFormatField = value;
            }
        }
        public object currencyPositiveFormat {
            get {
                return this.currencyPositiveFormatField;
            }
            set {
                this.currencyPositiveFormatField = value;
            }
        }
        public object dateFormat {
            get {
                return this.dateFormatField;
            }
            set {
                this.dateFormatField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object displayTaxCategorySuperscripts {
            get {
                return this.displayTaxCategorySuperscriptsField;
            }
            set {
                this.displayTaxCategorySuperscriptsField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object lastActivityBy {
            get {
                return this.lastActivityByField;
            }
            set {
                this.lastActivityByField = value;
            }
        }
        public object lastActivityDate {
            get {
                return this.lastActivityDateField;
            }
            set {
                this.lastActivityDateField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object numberFormat {
            get {
                return this.numberFormatField;
            }
            set {
                this.numberFormatField = value;
            }
        }
        public object pageLayout {
            get {
                return this.pageLayoutField;
            }
            set {
                this.pageLayoutField = value;
            }
        }
        public object pageNumberFormat {
            get {
                return this.pageNumberFormatField;
            }
            set {
                this.pageNumberFormatField = value;
            }
        }
        public object showEachTaxInGroup {
            get {
                return this.showEachTaxInGroupField;
            }
            set {
                this.showEachTaxInGroupField = value;
            }
        }
        public object showGridHeader {
            get {
                return this.showGridHeaderField;
            }
            set {
                this.showGridHeaderField = value;
            }
        }
        public object showTaxCategory {
            get {
                return this.showTaxCategoryField;
            }
            set {
                this.showTaxCategoryField = value;
            }
        }
        public object showVerticalGridLines {
            get {
                return this.showVerticalGridLinesField;
            }
            set {
                this.showVerticalGridLinesField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ResourceRole {

        private object idField;
        private object departmentIDField;
        private object isActiveField;
        private object queueIDField;
        private object resourceIDField;
        private object roleIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object departmentID {
            get {
                return this.departmentIDField;
            }
            set {
                this.departmentIDField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object queueID {
            get {
                return this.queueIDField;
            }
            set {
                this.queueIDField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object roleID {
            get {
                return this.roleIDField;
            }
            set {
                this.roleIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ServiceLevelAgreementResults {

        private object idField;
        private object firstResponseElapsedHoursField;
        private object firstResponseInitiatingResourceIDField;
        private object firstResponseResourceIDField;
        private object isFirstResponseMetField;
        private object isResolutionMetField;
        private object isResolutionPlanMetField;
        private object resolutionElapsedHoursField;
        private object resolutionPlanElapsedHoursField;
        private object resolutionPlanResourceIDField;
        private object resolutionResourceIDField;
        private object serviceLevelAgreementNameField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object firstResponseElapsedHours {
            get {
                return this.firstResponseElapsedHoursField;
            }
            set {
                this.firstResponseElapsedHoursField = value;
            }
        }
        public object firstResponseInitiatingResourceID {
            get {
                return this.firstResponseInitiatingResourceIDField;
            }
            set {
                this.firstResponseInitiatingResourceIDField = value;
            }
        }
        public object firstResponseResourceID {
            get {
                return this.firstResponseResourceIDField;
            }
            set {
                this.firstResponseResourceIDField = value;
            }
        }
        public object isFirstResponseMet {
            get {
                return this.isFirstResponseMetField;
            }
            set {
                this.isFirstResponseMetField = value;
            }
        }
        public object isResolutionMet {
            get {
                return this.isResolutionMetField;
            }
            set {
                this.isResolutionMetField = value;
            }
        }
        public object isResolutionPlanMet {
            get {
                return this.isResolutionPlanMetField;
            }
            set {
                this.isResolutionPlanMetField = value;
            }
        }
        public object resolutionElapsedHours {
            get {
                return this.resolutionElapsedHoursField;
            }
            set {
                this.resolutionElapsedHoursField = value;
            }
        }
        public object resolutionPlanElapsedHours {
            get {
                return this.resolutionPlanElapsedHoursField;
            }
            set {
                this.resolutionPlanElapsedHoursField = value;
            }
        }
        public object resolutionPlanResourceID {
            get {
                return this.resolutionPlanResourceIDField;
            }
            set {
                this.resolutionPlanResourceIDField = value;
            }
        }
        public object resolutionResourceID {
            get {
                return this.resolutionResourceIDField;
            }
            set {
                this.resolutionResourceIDField = value;
            }
        }
        public object serviceLevelAgreementName {
            get {
                return this.serviceLevelAgreementNameField;
            }
            set {
                this.serviceLevelAgreementNameField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class ShippingType {

        private object idField;
        private object billingCodeIDField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object billingCodeID {
            get {
                return this.billingCodeIDField;
            }
            set {
                this.billingCodeIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Skill {

        private object idField;
        private object categoryIDField;
        private object descriptionField;
        private object isActiveField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object categoryID {
            get {
                return this.categoryIDField;
            }
            set {
                this.categoryIDField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class SubscriptionPeriod {

        private object idField;
        private object periodCostField;
        private object periodDateField;
        private object periodPriceField;
        private object postedDateField;
        private object purchaseOrderNumberField;
        private object subscriptionIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object periodCost {
            get {
                return this.periodCostField;
            }
            set {
                this.periodCostField = value;
            }
        }
        public object periodDate {
            get {
                return this.periodDateField;
            }
            set {
                this.periodDateField = value;
            }
        }
        public object periodPrice {
            get {
                return this.periodPriceField;
            }
            set {
                this.periodPriceField = value;
            }
        }
        public object postedDate {
            get {
                return this.postedDateField;
            }
            set {
                this.postedDateField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object subscriptionID {
            get {
                return this.subscriptionIDField;
            }
            set {
                this.subscriptionIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class SurveyResults {

        private object idField;
        private object companyIDField;
        private object companyRatingField;
        private object completeDateField;
        private object contactIDField;
        private object contactRatingField;
        private object resourceRatingField;
        private object sendDateField;
        private object surveyIDField;
        private object surveyRatingField;
        private object ticketIDField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object companyID {
            get {
                return this.companyIDField;
            }
            set {
                this.companyIDField = value;
            }
        }
        public object companyRating {
            get {
                return this.companyRatingField;
            }
            set {
                this.companyRatingField = value;
            }
        }
        public object completeDate {
            get {
                return this.completeDateField;
            }
            set {
                this.completeDateField = value;
            }
        }
        public object contactID {
            get {
                return this.contactIDField;
            }
            set {
                this.contactIDField = value;
            }
        }
        public object contactRating {
            get {
                return this.contactRatingField;
            }
            set {
                this.contactRatingField = value;
            }
        }
        public object resourceRating {
            get {
                return this.resourceRatingField;
            }
            set {
                this.resourceRatingField = value;
            }
        }
        public object sendDate {
            get {
                return this.sendDateField;
            }
            set {
                this.sendDateField = value;
            }
        }
        public object surveyID {
            get {
                return this.surveyIDField;
            }
            set {
                this.surveyIDField = value;
            }
        }
        public object surveyRating {
            get {
                return this.surveyRatingField;
            }
            set {
                this.surveyRatingField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class Survey {

        private object idField;
        private object descriptionField;
        private object displayNameField;
        private object nameField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object displayName {
            get {
                return this.displayNameField;
            }
            set {
                this.displayNameField = value;
            }
        }
        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketCategoryFieldDefaults {

        private object idField;
        private object descriptionField;
        private object estimatedHoursField;
        private object issueTypeIDField;
        private object organizationalLevelAssociationIDField;
        private object priorityField;
        private object purchaseOrderNumberField;
        private object queueIDField;
        private object resolutionField;
        private object serviceLevelAgreementIDField;
        private object sourceIDField;
        private object statusField;
        private object subIssueTypeIDField;
        private object ticketCategoryIDField;
        private object ticketTypeIDField;
        private object titleField;
        private object workTypeIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object estimatedHours {
            get {
                return this.estimatedHoursField;
            }
            set {
                this.estimatedHoursField = value;
            }
        }
        public object issueTypeID {
            get {
                return this.issueTypeIDField;
            }
            set {
                this.issueTypeIDField = value;
            }
        }
        public object organizationalLevelAssociationID {
            get {
                return this.organizationalLevelAssociationIDField;
            }
            set {
                this.organizationalLevelAssociationIDField = value;
            }
        }
        public object priority {
            get {
                return this.priorityField;
            }
            set {
                this.priorityField = value;
            }
        }
        public object purchaseOrderNumber {
            get {
                return this.purchaseOrderNumberField;
            }
            set {
                this.purchaseOrderNumberField = value;
            }
        }
        public object queueID {
            get {
                return this.queueIDField;
            }
            set {
                this.queueIDField = value;
            }
        }
        public object resolution {
            get {
                return this.resolutionField;
            }
            set {
                this.resolutionField = value;
            }
        }
        public object serviceLevelAgreementID {
            get {
                return this.serviceLevelAgreementIDField;
            }
            set {
                this.serviceLevelAgreementIDField = value;
            }
        }
        public object sourceID {
            get {
                return this.sourceIDField;
            }
            set {
                this.sourceIDField = value;
            }
        }
        public object status {
            get {
                return this.statusField;
            }
            set {
                this.statusField = value;
            }
        }
        public object subIssueTypeID {
            get {
                return this.subIssueTypeIDField;
            }
            set {
                this.subIssueTypeIDField = value;
            }
        }
        public object ticketCategoryID {
            get {
                return this.ticketCategoryIDField;
            }
            set {
                this.ticketCategoryIDField = value;
            }
        }
        public object ticketTypeID {
            get {
                return this.ticketTypeIDField;
            }
            set {
                this.ticketTypeIDField = value;
            }
        }
        public object title {
            get {
                return this.titleField;
            }
            set {
                this.titleField = value;
            }
        }
        public object workTypeID {
            get {
                return this.workTypeIDField;
            }
            set {
                this.workTypeIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class TicketHistory {

        private object idField;
        private object actionField;
        private object dateField;
        private object detailField;
        private object resourceIDField;
        private object ticketIDField;
        private object soapParentPropertyIdField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object action {
            get {
                return this.actionField;
            }
            set {
                this.actionField = value;
            }
        }
        public object date {
            get {
                return this.dateField;
            }
            set {
                this.dateField = value;
            }
        }
        public object detail {
            get {
                return this.detailField;
            }
            set {
                this.detailField = value;
            }
        }
        public object resourceID {
            get {
                return this.resourceIDField;
            }
            set {
                this.resourceIDField = value;
            }
        }
        public object ticketID {
            get {
                return this.ticketIDField;
            }
            set {
                this.ticketIDField = value;
            }
        }
        public object soapParentPropertyId {
            get {
                return this.soapParentPropertyIdField;
            }
            set {
                this.soapParentPropertyIdField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class WebhookEventErrorLog {

        private object idField;
        private object accountWebhookIDField;
        private object contactWebhookIDField;
        private object createDateTimeField;
        private object errorMessageField;
        private object payloadField;
        private object sequenceNumberField;
        private object userDefinedFieldsField;
  

        public object id {
            get {
                return this.idField;
            }
            set {
                this.idField = value;
            }
        }
        public object accountWebhookID {
            get {
                return this.accountWebhookIDField;
            }
            set {
                this.accountWebhookIDField = value;
            }
        }
        public object contactWebhookID {
            get {
                return this.contactWebhookIDField;
            }
            set {
                this.contactWebhookIDField = value;
            }
        }
        public object createDateTime {
            get {
                return this.createDateTimeField;
            }
            set {
                this.createDateTimeField = value;
            }
        }
        public object errorMessage {
            get {
                return this.errorMessageField;
            }
            set {
                this.errorMessageField = value;
            }
        }
        public object payload {
            get {
                return this.payloadField;
            }
            set {
                this.payloadField = value;
            }
        }
        public object sequenceNumber {
            get {
                return this.sequenceNumberField;
            }
            set {
                this.sequenceNumberField = value;
            }
        }
        public object userDefinedFields {
            get {
                return this.userDefinedFieldsField;
            }
            set {
                this.userDefinedFieldsField = value;
            }
        }

    }

    public class OperationResult {

        private object itemIdField;
  

        public object itemId {
            get {
                return this.itemIdField;
            }
            set {
                this.itemIdField = value;
            }
        }

    }

    public class QueryCountResult {

        private object queryCountField;
  

        public object queryCount {
            get {
                return this.queryCountField;
            }
            set {
                this.queryCountField = value;
            }
        }

    }

    public class EntityInformationResult {

        private object infoField;
  

        public object info {
            get {
                return this.infoField;
            }
            set {
                this.infoField = value;
            }
        }

    }

    public class EntityInformation {

        private object nameField;
        private object canCreateField;
        private object canDeleteField;
        private object canQueryField;
        private object canUpdateField;
        private object userAccessForCreateField;
        private object userAccessForDeleteField;
        private object userAccessForQueryField;
        private object userAccessForUpdateField;
        private object hasUserDefinedFieldsField;
        private object supportsWebhookCalloutsField;
  

        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object canCreate {
            get {
                return this.canCreateField;
            }
            set {
                this.canCreateField = value;
            }
        }
        public object canDelete {
            get {
                return this.canDeleteField;
            }
            set {
                this.canDeleteField = value;
            }
        }
        public object canQuery {
            get {
                return this.canQueryField;
            }
            set {
                this.canQueryField = value;
            }
        }
        public object canUpdate {
            get {
                return this.canUpdateField;
            }
            set {
                this.canUpdateField = value;
            }
        }
        public object userAccessForCreate {
            get {
                return this.userAccessForCreateField;
            }
            set {
                this.userAccessForCreateField = value;
            }
        }
        public object userAccessForDelete {
            get {
                return this.userAccessForDeleteField;
            }
            set {
                this.userAccessForDeleteField = value;
            }
        }
        public object userAccessForQuery {
            get {
                return this.userAccessForQueryField;
            }
            set {
                this.userAccessForQueryField = value;
            }
        }
        public object userAccessForUpdate {
            get {
                return this.userAccessForUpdateField;
            }
            set {
                this.userAccessForUpdateField = value;
            }
        }
        public object hasUserDefinedFields {
            get {
                return this.hasUserDefinedFieldsField;
            }
            set {
                this.hasUserDefinedFieldsField = value;
            }
        }
        public object supportsWebhookCallouts {
            get {
                return this.supportsWebhookCalloutsField;
            }
            set {
                this.supportsWebhookCalloutsField = value;
            }
        }

    }

    public class FieldInformationResult {

        private object fieldsField;
  

        public object fields {
            get {
                return this.fieldsField;
            }
            set {
                this.fieldsField = value;
            }
        }

    }

    public class FieldInformation {

        private object nameField;
        private object dataTypeField;
        private object lengthField;
        private object isRequiredField;
        private object isReadOnlyField;
        private object isQueryableField;
        private object isReferenceField;
        private object referenceEntityTypeField;
        private object isPickListField;
        private object picklistValuesField;
        private object picklistParentValueFieldField;
        private object isSupportedWebhookFieldField;
  

        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object dataType {
            get {
                return this.dataTypeField;
            }
            set {
                this.dataTypeField = value;
            }
        }
        public object length {
            get {
                return this.lengthField;
            }
            set {
                this.lengthField = value;
            }
        }
        public object isRequired {
            get {
                return this.isRequiredField;
            }
            set {
                this.isRequiredField = value;
            }
        }
        public object isReadOnly {
            get {
                return this.isReadOnlyField;
            }
            set {
                this.isReadOnlyField = value;
            }
        }
        public object isQueryable {
            get {
                return this.isQueryableField;
            }
            set {
                this.isQueryableField = value;
            }
        }
        public object isReference {
            get {
                return this.isReferenceField;
            }
            set {
                this.isReferenceField = value;
            }
        }
        public object referenceEntityType {
            get {
                return this.referenceEntityTypeField;
            }
            set {
                this.referenceEntityTypeField = value;
            }
        }
        public object isPickList {
            get {
                return this.isPickListField;
            }
            set {
                this.isPickListField = value;
            }
        }
        public object picklistValues {
            get {
                return this.picklistValuesField;
            }
            set {
                this.picklistValuesField = value;
            }
        }
        public object picklistParentValueField {
            get {
                return this.picklistParentValueFieldField;
            }
            set {
                this.picklistParentValueFieldField = value;
            }
        }
        public object isSupportedWebhookField {
            get {
                return this.isSupportedWebhookFieldField;
            }
            set {
                this.isSupportedWebhookFieldField = value;
            }
        }

    }

    public class PickListValue {

        private object valueField;
        private object labelField;
        private object isDefaultValueField;
        private object sortOrderField;
        private object parentValueField;
        private object isActiveField;
        private object isSystemField;
  

        public object value {
            get {
                return this.valueField;
            }
            set {
                this.valueField = value;
            }
        }
        public object label {
            get {
                return this.labelField;
            }
            set {
                this.labelField = value;
            }
        }
        public object isDefaultValue {
            get {
                return this.isDefaultValueField;
            }
            set {
                this.isDefaultValueField = value;
            }
        }
        public object sortOrder {
            get {
                return this.sortOrderField;
            }
            set {
                this.sortOrderField = value;
            }
        }
        public object parentValue {
            get {
                return this.parentValueField;
            }
            set {
                this.parentValueField = value;
            }
        }
        public object isActive {
            get {
                return this.isActiveField;
            }
            set {
                this.isActiveField = value;
            }
        }
        public object isSystem {
            get {
                return this.isSystemField;
            }
            set {
                this.isSystemField = value;
            }
        }

    }

    public class UserDefinedFieldInformationResult {

        private object fieldsField;
  

        public object fields {
            get {
                return this.fieldsField;
            }
            set {
                this.fieldsField = value;
            }
        }

    }

    public class Field {

        private object nameField;
        private object labelField;
        private object typeField;
        private object lengthField;
        private object descriptionField;
        private object isRequiredField;
        private object isReadOnlyField;
        private object isQueryableField;
        private object isReferenceField;
        private object referenceEntityTypeField;
        private object isPickListField;
        private object picklistValuesField;
        private object picklistParentValueFieldField;
        private object defaultValueField;
        private object isSupportedWebhookFieldField;
  

        public object name {
            get {
                return this.nameField;
            }
            set {
                this.nameField = value;
            }
        }
        public object label {
            get {
                return this.labelField;
            }
            set {
                this.labelField = value;
            }
        }
        public object type {
            get {
                return this.typeField;
            }
            set {
                this.typeField = value;
            }
        }
        public object length {
            get {
                return this.lengthField;
            }
            set {
                this.lengthField = value;
            }
        }
        public object description {
            get {
                return this.descriptionField;
            }
            set {
                this.descriptionField = value;
            }
        }
        public object isRequired {
            get {
                return this.isRequiredField;
            }
            set {
                this.isRequiredField = value;
            }
        }
        public object isReadOnly {
            get {
                return this.isReadOnlyField;
            }
            set {
                this.isReadOnlyField = value;
            }
        }
        public object isQueryable {
            get {
                return this.isQueryableField;
            }
            set {
                this.isQueryableField = value;
            }
        }
        public object isReference {
            get {
                return this.isReferenceField;
            }
            set {
                this.isReferenceField = value;
            }
        }
        public object referenceEntityType {
            get {
                return this.referenceEntityTypeField;
            }
            set {
                this.referenceEntityTypeField = value;
            }
        }
        public object isPickList {
            get {
                return this.isPickListField;
            }
            set {
                this.isPickListField = value;
            }
        }
        public object picklistValues {
            get {
                return this.picklistValuesField;
            }
            set {
                this.picklistValuesField = value;
            }
        }
        public object picklistParentValueField {
            get {
                return this.picklistParentValueFieldField;
            }
            set {
                this.picklistParentValueFieldField = value;
            }
        }
        public object defaultValue {
            get {
                return this.defaultValueField;
            }
            set {
                this.defaultValueField = value;
            }
        }
        public object isSupportedWebhookField {
            get {
                return this.isSupportedWebhookFieldField;
            }
            set {
                this.isSupportedWebhookFieldField = value;
            }
        }

    }

    public class ApiVersionResult {

        private object apiVersionsField;
  

        public object apiVersions {
            get {
                return this.apiVersionsField;
            }
            set {
                this.apiVersionsField = value;
            }
        }

    }

    public class AutotaskVersionResult {

        private object majorVersionField;
        private object minorVersionField;
        private object buildField;
  

        public object majorVersion {
            get {
                return this.majorVersionField;
            }
            set {
                this.majorVersionField = value;
            }
        }
        public object minorVersion {
            get {
                return this.minorVersionField;
            }
            set {
                this.minorVersionField = value;
            }
        }
        public object build {
            get {
                return this.buildField;
            }
            set {
                this.buildField = value;
            }
        }

    }

    public class GlobalEntityInformationResult {

        private object entityDescriptionsField;
  

        public object entityDescriptions {
            get {
                return this.entityDescriptionsField;
            }
            set {
                this.entityDescriptionsField = value;
            }
        }

    }

    public class ModuleAccessResult {

        private object modulesField;
  

        public object modules {
            get {
                return this.modulesField;
            }
            set {
                this.modulesField = value;
            }
        }

    }

    public class KeyValuePair {

        private object keyField;
        private object valueField;
  

        public object key {
            get {
                return this.keyField;
            }
            set {
                this.keyField = value;
            }
        }
        public object value {
            get {
                return this.valueField;
            }
            set {
                this.valueField = value;
            }
        }

    }

    public class ThresholdStatusResult {

        private object externalRequestThresholdField;
        private object requestThresholdTimeframeField;
        private object currentTimeframeRequestCountField;
  

        public object externalRequestThreshold {
            get {
                return this.externalRequestThresholdField;
            }
            set {
                this.externalRequestThresholdField = value;
            }
        }
        public object requestThresholdTimeframe {
            get {
                return this.requestThresholdTimeframeField;
            }
            set {
                this.requestThresholdTimeframeField = value;
            }
        }
        public object currentTimeframeRequestCount {
            get {
                return this.currentTimeframeRequestCountField;
            }
            set {
                this.currentTimeframeRequestCountField = value;
            }
        }

    }

    public class ZoneInformationResult {

        private object zoneNameField;
        private object urlField;
        private object webUrlField;
        private object ciField;
  

        public object zoneName {
            get {
                return this.zoneNameField;
            }
            set {
                this.zoneNameField = value;
            }
        }
        public object url {
            get {
                return this.urlField;
            }
            set {
                this.urlField = value;
            }
        }
        public object webUrl {
            get {
                return this.webUrlField;
            }
            set {
                this.webUrlField = value;
            }
        }
        public object ci {
            get {
                return this.ciField;
            }
            set {
                this.ciField = value;
            }
        }

    }

}
