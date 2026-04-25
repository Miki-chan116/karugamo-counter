const SHEET_NAME = 'logs';

function doPost(e) {
  try {
    const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(SHEET_NAME);

    if (!sheet) {
      throw new Error(`${SHEET_NAME}シートが見つかりません`);
    }

    const data = JSON.parse(e.postData.contents);
    const logs = data.logs || [];

    if (!Array.isArray(logs) || logs.length === 0) {
      throw new Error('保存するデータがありません');
    }

    const startRow = sheet.getLastRow() + 1;
    const createdAt = formatDateTimeJst_(new Date());

    const rows = logs.map((log, index) => [
      startRow - 1 + index,
      log.driver_name || '',
      log.driver_phone || '',
      log.device_id || '',
      log.press_count || '',
      log.interval_ms || '',
      log.recorded_at || '',
      createdAt,
      log.memo || ''
    ]);

    sheet
      .getRange(startRow, 1, rows.length, rows[0].length)
      .setValues(rows);

    return jsonResponse({
      status: 'success',
      saved_count: rows.length
    });

  } catch (error) {
    return jsonResponse({
      status: 'error',
      message: error.message
    });
  }
}

function doGet(e) {
  const page = e && e.parameter && e.parameter.page
    ? e.parameter.page
    : 'index';

  const allowedPages = [
    'index',
    'register',
    'edit',
    'today',
    'history',
  ];

  const targetPage = allowedPages.includes(page) ? page : 'index';

  return HtmlService
    .createTemplateFromFile(targetPage)
    .evaluate()
    .setTitle('カルガモカウンター')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1.0');
}

function jsonResponse(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}

function saveLogsFromWeb(logs) {
  try {
    const sheet = SpreadsheetApp
      .getActiveSpreadsheet()
      .getSheetByName(SHEET_NAME);

    if (!sheet) {
      throw new Error(`${SHEET_NAME}シートが見つかりません`);
    }

    if (!Array.isArray(logs) || logs.length === 0) {
      throw new Error('保存するデータがありません');
    }

    const startRow = sheet.getLastRow() + 1;
    const createdAt = formatDateTimeJst_(new Date());

    const rows = logs.map((log, index) => [
      startRow - 1 + index,
      log.driver_name || '',
      log.driver_phone || '',
      log.device_id || '',
      log.press_count || '',
      log.interval_ms || '',
      log.recorded_at || '',
      createdAt,
      log.memo || ''
    ]);

    sheet
      .getRange(startRow, 1, rows.length, rows[0].length)
      .setValues(rows);

    return {
      status: 'success',
      saved_count: rows.length
    };

  } catch (error) {
    throw new Error(error.message);
  }
}

function formatDateTimeJst_(date) {
  return Utilities.formatDate(
    date,
    'Asia/Tokyo',
    'yyyy/MM/dd HH:mm:ss'
  );
}