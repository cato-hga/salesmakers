class SeedVonageDocusignTemplates < ActiveRecord::Migration
  def self.up
    t = []
    t << { state: 'AK', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'FL', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'NV', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'SD', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'TX', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'WA', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'WY', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'NH', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'TN', template_guid: 'BCDA79DF-21E1-4726-96A6-AC2AAD715BB5' }
    t << { state: 'AZ', template_guid: '21C0144C-912F-4816-BA47-80E3034A5810' }
    t << { state: 'CA', template_guid: '1FEA7BA5-BBA1-4196-AC4F-0B79F26BB927' }
    t << { state: 'CO', template_guid: '27DF6670-AC68-451F-8D4C-C85EEEE4079A' }
    t << { state: 'CT', template_guid: '0EFE2266-746D-4343-AE5A-BDC2A53FC257' }
    t << { state: 'DC', template_guid: 'CDB19FF8-7CBF-4038-BD63-E85CEF7C4DF4' }
    t << { state: 'DE', template_guid: '0FD1B42E-7307-4767-A38B-66BDE67490A5' }
    t << { state: 'GA', template_guid: '88DD7700-8AF1-42A0-9D0D-84E42AF5D848' }
    t << { state: 'ID', template_guid: '46E7897C-81D5-4971-A178-A5D953DC5922' }
    t << { state: 'IL', template_guid: '3E2BBE76-F1B2-450D-A579-2FAB14F74117' }
    t << { state: 'IN', template_guid: 'A91057A2-6DB1-4638-A090-9ECFF77632EE' }
    t << { state: 'MD', template_guid: 'A170E399-4636-4634-A9FD-9993CB14854A' }
    t << { state: 'MA', template_guid: '91D72938-7F5D-44FC-BCE9-D43FF46F8E9B' }
    t << { state: 'MN', template_guid: '79B00DF8-C22E-4870-99C2-D8474384FF6E' }
    t << { state: 'MO', template_guid: '580F5312-0457-4B81-8CFC-728045CA20C3' }
    t << { state: 'NJ', template_guid: '19E2C23F-98CC-429B-B381-A7EC26E71883' }
    t << { state: 'NM', template_guid: '71031B4A-8CEA-495C-AC43-E2FAAE1DA535' }
    t << { state: 'NY', template_guid: '875E05B7-C220-4144-ADEE-C0A76FDEAD87' }
    t << { state: 'NC', template_guid: '291B9DD8-0DCF-4DA0-993C-D86DF837176F' }
    t << { state: 'OH', template_guid: '378E35FF-8979-4BFC-AFBF-4DB2025A32D2' }
    t << { state: 'OK', template_guid: '90182A39-9FF0-4E29-9836-47835116A983' }
    t << { state: 'OR', template_guid: '23121C1D-4F30-4A34-BBA0-BB9863AD1B02' }
    t << { state: 'PA', template_guid: '6F3FD25C-07D2-4498-9591-C6C17F1A428A' }
    t << { state: 'RI', template_guid: '3A702487-808E-4E13-8A60-909EFFFFB469' }
    t << { state: 'SC', template_guid: '17B6B4E1-15B5-4C8C-9C38-D8980155F376' }
    t << { state: 'UT', template_guid: '799478FE-A631-459A-856A-23B0739BCD6E' }
    t << { state: 'VA', template_guid: '541DA653-22A1-4779-90C6-FC5886887F90' }
    t << { state: 'WI', template_guid: '8BBF9F1D-B77B-45BB-86CF-B939C6A824BA' }
    vr = Project.find_by name: 'Vonage Retail'
    ve = Project.find_by name: 'Vonage Events'
    for template in t do
      DocusignTemplate.find_or_create_by template.merge project: vr, document_type: :nhp
      DocusignTemplate.find_or_create_by template.merge project: ve, document_type: :nhp
    end
  end

  def self.down
    vr = Project.find_by name: 'Vonage Retail'
    ve = Project.find_by name: 'Vonage Events'
    DocusignTemplate.where(project: vr).destroy_all
    DocusignTemplate.where(project: ve).destroy_all
  end
end
