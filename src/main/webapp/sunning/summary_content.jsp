<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<div class="col-xs-12">
    <div class="col-xs-6">
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="6" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">处方总况</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc"><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>全院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>门诊</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>住院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>说明</strong></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">金额</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAmount+stat.hospitalAmount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAmount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalAmount}"/></td>
                <td align="right">&nbsp;</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">就诊人次</td>
                <td align="right">${stat.clinicPatient+stat.hospitalPatient}</td>
                <td align="right">${stat.clinicPatient}</td>
                <td align="right">${stat.inHospitalPatient}</td>
                <td align="left">全院：门诊人数+住院开药人数<br/>住院：入院人数<br/>急诊患者人次：${stat.emergPatient}</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">静脉注射人次</td>
                <td align="right">-</td>
                <td align="right">${stat.vdPatient}</td>
                <td align="right">-</td>
                <td align="left">门急诊</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">平均药费</td>
                <td align="right">-</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAmount/stat.clinicPatient}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAmount/stat.outHospitalPatient}"/></td>
                <td align="left">门诊：每次就诊费用<br/>住院：总金额／出院人数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">平均品种数</td>
                <td align="right">-</td>
                <td align="right"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicDrugNum*1.0/stat.clinicPatient}"/></td>
                <td align="right"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalDrugNum*1.0/stat.outHospitalPatient}"/></td>
                <td align="left">门诊：人均就诊品种数<br/>住院：总用药品种数／出院人数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">甲类医保用药金额</td>
                <td align="right" rowspan="2">￥<fmt:formatNumber type="number" maxFractionDigits="0"
                                                                 value="${stat.clinicInsuranceAAmount+stat.hospitalInsuranceAAmount+stat.hospitalInsuranceBAmount}"/>
                </td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicInsuranceAAmount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalInsuranceAAmount}"/></td>
                <td align="right"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">乙类医保用药金额</td>
                <td align="right">-</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalInsuranceBAmount}"/></td>
                <td align="right"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">甲类医保药品种比例</td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                                    value="${(stat.clinicInsuranceADrugNum+stat.hospitalInsuranceADrugNum)*1.0/(stat.clinicDrugNum+stat.hospitalDrugNum)}"/>
                </td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicInsuranceADrugNum*1.0/stat.clinicDrugNum}"/></td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalInsuranceADrugNum*1.0/stat.hospitalDrugNum}"/></td>
                <td align="left">甲类医保药品种数／总用药品种数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">乙类医保药品种比例</td>
                <td align="right">-</td>
                <td align="right">-</td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalInsuranceBDrugNum*1.0/stat.hospitalDrugNum}"/></td>
                <td align="left">乙类医保药品种数／总用药品种数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">基本药物金额</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicBaseAmount+stat.hospitalBaseAmount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicBaseAmount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalBaseAmount}"/></td>
                <td align="right"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">基本药物比例</td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                                    value="${(stat.clinicBaseDrugNum+stat.hospitalBaseDrugNum)*1.0/(stat.clinicDrugNum+stat.hospitalDrugNum)}"/></td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicBaseDrugNum*1.0/stat.clinicDrugNum}"/></td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalBaseDrugNum*1.0/stat.hospitalDrugNum}"/></td>
                <td align="left">基药品种数／总用药品种数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">注射剂使用率</td>
                <td align="right">-</td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicInjectPatient*1.0/stat.clinicPatient}"/></td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalInjectPatient*1.0/stat.hospitalPatient2}"/></td>
                <td align="left">门诊：使用注射剂人数／门诊人数 <br/> 住院：出院病人用注射剂人数／出院人数</td>
            </tr>
        </table>
        <div class="row col-xs-12" style="height: 10px"></div>
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="4" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">其他关键指标</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc"><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc" nowrap="true"><strong>数值</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>比率</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>说明</strong></td>
            </tr>
            <%--    <tr align="right">
                <td bgColor="#75c8cc" align="center" >Ⅰ类切口手术预防用抗菌药物百分率</td>
                <td>${stat.microbeCheckCount}</td>
                <td><c:text name="format.percent"><c:param value='stat.microbeCheckCount*1.0/stat.oneIncisionCount'/></s:text></td>
                <td align="left">Ⅰ类切口手术使用抗菌药人数／<br/>Ⅰ类切口手术人数</td>
            </tr>--%>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药住院患者微生物样本送检率</td>
                <td>${stat.microbeCheckCount}</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeCheckCount*1.0/(stat.outAntiParent-stat.outOneIncisionAntiParent)}"/></td>
                <td align="left">微生物样本送检数／<br/>（出院病人用抗菌药人数－Ⅰ类切口出院病人用抗菌药人数）</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">Ⅰ类切口术前0.5-2.0小时给药率</td>
                <td>${stat.oneIncisionDrug}</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.oneIncisionDrug*1.0/stat.oneIncisionCount}"/></td>
                <td align="left">Ⅰ类切口术前0.5-2.0小时给药人数<br/>／Ⅰ类切口手术数</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">Ⅰ类切口术抗菌药使用率</td>
                <td>${stat.outOneIncisionAntiParent}</td>
                <td><c:choose><c:when test="stat.outOneIncisionAntiParent>stat.oneIncisionCount">100%</c:when>
                    <c:otherwise><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.outOneIncisionAntiParent*1.0/stat.oneIncisionCount}"/></c:otherwise>
                </c:choose></td>
                <td align="left">Ⅰ类切口出院病人用抗菌药人数<br/>／Ⅰ类切口手术数</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">限制级抗菌药微生物送检率</td>
                <td>${stat.microbeLimit}</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeLimit*1.0/stat.hospitalLimitAntiPatient}"/>
                </td>
                <td align="left">用限制抗菌药病人微生物送检数<br/>／用限制抗菌药病人数</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">特殊级抗菌药微生物送检率</td>
                <td>${stat.microbeSpec}</td>
                <td>
                    <c:choose><c:when test='stat.microbeSpec<stat.hospitalSpecAntiPatient'>
                        <fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeSpec*1.0/stat.hospitalSpecAntiPatient}"/></c:when>
                        <c:otherwise>100.0%</c:otherwise>
                    </c:choose></td>
                <td align="left">用特殊抗菌药病人微生物送检数<br/>／用特殊抗菌药病人数</td>
            </tr>
        </table>
    </div>
    <div class="col-xs-6">
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="6" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">抗菌药物</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc" ><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>全院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>门诊</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>住院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>说明</strong></td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药金额</td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAntiAmount+stat.hospitalAntiAmount}"/></td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAntiAmount}"/></td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalAntiAmount}"/></td>
                <td align="left"></td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">金额比例</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicAntiAmount+stat.hospitalAntiAmount) * 100.0 / (stat.clinicAmount+stat.hospitalAmount) }"/>%
                </td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiAmount * 100.0 / stat.clinicAmount}"/>%</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAntiAmount * 100.0 / stat.hospitalAmount}"/>%</td>
                <td align="left">抗菌药金额／总药品金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">使用率</td>
                <td>-</td>
                <td><fmt:formatNumber type="percent" maxFractionDigits="2" value="${stat.clinicAntiPatient * 1.0 / stat.clinicPatient2}"/></td>
                <td><fmt:formatNumber type="percent" maxFractionDigits="2" value="${stat.hospitalAntiPatient * 1.0 / stat.outHospitalPatient}"/></td>
                <td align="left">门诊：抗菌药处方数／就诊人次(${stat.clinicPatient2})<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（急诊、儿科、草药除外）
                    <br/>住院：抗菌药用药人数／出院病人数(${stat.outHospitalPatient}) <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（整个住院期间用过抗菌药的）
                </td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">平均费用</td>
                <td>-</td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiAmount / stat.clinicAntiPatient}"/></td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAntiAmount / stat.hospitalAntiPatient}"/></td>
                <td align="left">抗菌药总金额／抗菌药用药人数<br/>(门诊：${stat.clinicAntiPatient}，住院：${stat.hospitalAntiPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">平均品种数</td>
                <td>-</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiNum * 1.0 / stat.clinicAntiPatient}"/></td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAntiNum * 1.0 / stat.hospitalAntiPatient}"/></td>
                <td align="left">抗菌药品种数／抗菌药用药人数</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">注射金额比例</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicInjectAntiAmount+stat.hospitalInjectAntiAmount)*100.0/(stat.clinicAmount+stat.hospitalAmount)}"/>%
                </td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicInjectAntiAmount*100.0/stat.clinicAmount}"/>%</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalInjectAntiAmount*100.0/stat.hospitalAmount}"/>%</td>
                <td align="left">注射抗菌药药品金额／药品总金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">注射使用率</td>
                <td>-</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicInjectAntiPatient*1.0/stat.clinicPatient}"/></td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalInjectAntiPatient*1.0/stat.hospitalPatient2}"/></td>
                <td align="left">门诊：注射抗菌药用药人数(${stat.clinicInjectAntiPatient})／门诊人数<br/>住院：注射抗菌药用药人数(${stat.hospitalInjectAntiPatient})／住院用药人数
                </td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药物使用强度</td>
                <td>-</td>
                <td>-</td>
                <td><fmt:formatNumber type="NUMBER" maxFractionDigits="2" value="${stat.DDDs*100.0/stat.hospitalDay}"/></td>
                <td align="left">抗菌药物消耗量（累计DDD数）*100 <br/>／同期收治患者住院天数(${stat.hospitalDay}) <br/>（去除出院带药，不含留观号）</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">急诊抗菌<br/>药物处方比例</td>
                <td>-</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.emergencyAntiPatient*1.0/stat.emergencyPatient}"/></td>
                <td>-</td>
                <td align="left">急诊抗菌药处方／急诊使用药物人<br/>次数(${stat.emergencyPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">特殊品种费用占抗<br/>菌药物费用百分率</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                      value="${(stat.clinicSpecAntiAmount+stat.hospitalSpecAntiAmount)*1.0/(stat.clinicAntiAmount+stat.hospitalAntiAmount)}"/></td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicSpecAntiAmount*1.0/stat.clinicAntiAmount}"/></td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalSpecAntiAmount*1.0/stat.hospitalAntiAmount}"/></td>
                <td align="left">特殊抗菌药金额／抗菌药总金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">口服抗菌药<br/>占抗菌药金额</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicOrallyAntiAmount+stat.hospitalOrallyAntiAmount)*100.0/(stat.clinicAntiAmount+stat.hospitalAntiAmount)}"/>%
                </td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicOrallyAntiAmount*100.0/stat.clinicAntiAmount}"/>%</td>
                <td><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalOrallyAntiAmount*100.0/stat.hospitalAntiAmount}"/>%</td>
                <td align="left">口服抗菌药金额／抗菌药总金额</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">门诊抗菌药<br/>静脉注射人次</td>
                <td align="right">-</td>
                <td align="right">${stat.antiVdPatient}</td>
                <td align="right">-</td>
                <td align="left">含急诊</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">急诊抗菌药<br/>静脉注射人次</td>
                <td align="right">-</td>
                <td align="right">${stat.antiVdEmerPatient}</td>
                <td align="right">-</td>
                <td align="left"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">急诊抗菌药<br/>品种数</td>
                <td align="right">-</td>
                <td align="right">${stat.emergAntiDrugNum}</td>
                <td align="right">-</td>
                <td align="left"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">急诊抗菌药物费用</td>
                <td align="right">-</td>
                <td align="right">${stat.emergAntiDrugMoney}</td>
                <td align="right">-</td>
                <td align="left"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">急诊药物费用</td>
                <td align="right">-</td>
                <td align="right">￥<fmt:formatNumber type="NUMBER" maxFractionDigits="0" value="${stat.emergDrugMoney}"/></td>
                <td align="right">-</td>
                <td align="left"></td>
            </tr>
        </table>
        <div class="row col-xs-12" style="height: 10px"></div>
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="6" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">基本药物</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc"><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>品规数</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>销售金额</strong></td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">省级基本药物</td>
                <td>${stat.localBaseNum}</td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.localBaseMoney}"/></td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">国家基本药物</td>
                <td>${stat.nationBaseNum}</td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.nationBaseMoney}"/></td>
            </tr>
        </table>
    </div>
</div>