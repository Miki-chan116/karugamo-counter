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
    const createdAt = new Date();

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

function doGet() {
  return jsonResponse({
    status: 'ok',
    message: 'karugamo gas api is running'
  });
}

function jsonResponse(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}