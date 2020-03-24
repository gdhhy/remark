<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!--SQL 查询语句在Sunning.xml-->
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
                <td align="left">全院：门诊人数+住院开药人数<br/>住院：入院人数<br/>急诊用药病人数：${stat.emergPatient}</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">静脉注射人次</td>
                <td align="right">${stat.clinicVdPatient+stat.hospitalVdPatient}</td>
                <td align="right">${stat.clinicVdPatient}</td>
                <td align="right">${stat.hospitalVdPatient}</td>
                <td align="left">出院病人住院期间使用过静脉注射</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">平均药费</td>
                <td align="right">-</td> 
                <td align="right">￥<c:if test="stat.clinicPatient>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAmount/stat.clinicPatient}"/></c:if></td>
                <td align="right">￥<c:if test="stat.outHospitalPatient>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAmount/stat.outHospitalPatient}"/></c:if></td>
                <td align="left">门诊：每次就诊费用<br/>住院：总金额／出院人数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">平均品种数</td>
                <td align="right">-</td>
                <td align="right"><c:if test="stat.clinicPatient>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicDrugNum*1.0/stat.clinicPatient}"/></c:if></td>
                <td align="right"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalDrugNum*1.0/stat.outHospitalPatient}"/></td>
                <td align="left">门诊：人均就诊品种数（含草药）<br/>住院：总用药品种数／出院人数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">甲类医保用药金额</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinic_A_Amount+stat.hospital_A_Amount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinic_A_Amount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospital_A_Amount}"/></td>
                <td align="right"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">乙类医保用药金额</td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinic_B_Amount+stat.hospital_B_Amount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinic_B_Amount}"/></td>
                <td align="right">￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospital_B_Amount}"/></td>
                <td align="right"></td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">甲类医保品种比例</td>
                <td align="right"><c:if test="stat.clinicDrugNum+stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                                                                                         value="${(stat.clinic_A_DrugNum+stat.hospital_A_DrugNum)*1.0/(stat.clinicDrugNum+stat.hospitalDrugNum)}"/></c:if>
                </td>
                <td align="right"><c:if test="stat.clinicDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinic_A_DrugNum*1.0/stat.clinicDrugNum}"/></c:if></td>
                <td align="right"><c:if test="stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospital_A_DrugNum*1.0/stat.hospitalDrugNum}"/></c:if></td>
                <td align="left">甲类医保药品种数／总用药品种数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">乙类医保品种比例</td>
                <td align="right"><c:if test="stat.clinicDrugNum+stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                                                                                         value="${(stat.clinic_B_DrugNum+stat.hospital_B_DrugNum)*1.0/(stat.clinicDrugNum+stat.hospitalDrugNum)}"/></c:if>
                </td>
                <td align="right"><c:if test="stat.clinicDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinic_B_DrugNum*1.0/stat.clinicDrugNum}"/></c:if></td>
                <td align="right"><c:if test="stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospital_B_DrugNum*1.0/stat.hospitalDrugNum}"/></c:if></td>
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
                <td align="right"><c:if test="stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
value="${(stat.clinicBaseDrugNum+stat.hospitalBaseDrugNum)*1.0/(stat.clinicDrugNum+stat.hospitalDrugNum)}"/></c:if></td>
                <td align="right"><c:if test="stat.clinicDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicBaseDrugNum*1.0/stat.clinicDrugNum}"/></c:if></td>
                <td align="right"><c:if test="stat.hospitalDrugNum>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalBaseDrugNum*1.0/stat.hospitalDrugNum}"/></c:if></td>
                <td align="left">基药品种数／总用药品种数</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">注射剂使用率</td>
                <td align="right">-</td>
                <td align="right"><c:if test="stat.clinicPatient>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicInjectPatient*1.0/stat.clinicPatient}"/></c:if></td>
                <td align="right"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.outInjectPatient*1.0/stat.outHospitalPatient}"/></td>
                <td align="left">门诊：使用注射剂人数／门诊人数 <br/> 住院：出院病人用注射剂人数<br/>／出院人数</td>
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
            <tr align="right">
                <td bgColor="#75c8cc" align="center">Ⅰ类切口手术预防用<br/>抗菌药使用率</td>
                <td>${stat.onePrevAntiPatient}</td>
                <td><c:choose><c:when test='stat.oneIncisionPatient>0'>
                    <fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.onePrevAntiPatient*1.0/stat.oneIncisionPatient}"/></c:when>
                    <c:otherwise>0%</c:otherwise>
                </c:choose></td>
                <td align="left">Ⅰ类切口手术术前0.5-2小时使用抗菌药人数<br/>／Ⅰ类切口手术出院人数(${stat.oneIncisionPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">Ⅰ类切口手术<br/>抗菌药使用率</td>
                <td>${stat.oneAntiPatient}</td>
                <td><c:choose><c:when test='stat.oneIncisionPatient>0'>
                    <fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.oneAntiPatient*1.0/stat.oneIncisionPatient}"/></c:when>
                    <c:otherwise>0%</c:otherwise>
                </c:choose></td>
                <td align="left">Ⅰ类切口出院病人用抗菌药人数<br/>／Ⅰ类切口手术出院人数(${stat.oneIncisionPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药住院患者<br/>微生物送检率</td>
                <td>${stat.microbeCheckPatient}</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeCheckPatient*1.0/(stat.outAntiPatient-stat.onePrevAntiPatient)}"/></td>
                <td align="left">微生物样本送检：<i>医嘱含 涂片、细菌培养 字样</i><br/>微生物样本送检出院病人数／<br/>（出院病人用抗菌药人数－Ⅰ类切口手术预防用药人数）</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">限制级抗菌药<br/>微生物送检率</td>
                <td>${stat.microbeLimitPatient}</td>
                <td><c:choose><c:when test='stat.outAntiLimitPatient>0'>
                    <fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeLimitPatient*1.0/stat.outAntiLimitPatient}"/></c:when>
                    <c:otherwise>0%</c:otherwise>
                </c:choose></td>
                <td align="left">用限制抗菌药病人微生物送检数<br/>／用限制抗菌药病人数(${stat.outAntiLimitPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">特殊级抗菌药<br/>微生物送检率</td>
                <td>${stat.microbeSpecPatient}</td>
                <td><c:choose><c:when test='stat.outAntiSpecPatient>0'>
                    <fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.microbeSpecPatient*1.0/stat.outAntiSpecPatient}"/></c:when>
                    <c:otherwise>0%</c:otherwise>
                </c:choose></td>
                <td align="left">用特殊抗菌药病人微生物送检数<br/>／用特殊抗菌药病人数(${stat.outAntiSpecPatient})</td>
            </tr>
        </table>
    </div>
    <div class="col-xs-6">
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="6" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">抗菌药物</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc"><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>全院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>门诊</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>住院</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>说明</strong></td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药金额</td>
                <td>￥<fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAntiAmount+stat.hospitalAntiAmount}"/></td>
                <td>￥<c:if test="stat.clinicAntiAmount>0"><fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.clinicAntiAmount}"/></c:if></td>
                <td>￥<c:if test="stat.hospitalAntiAmount>0"><fmt:formatNumber type="number" maxFractionDigits="0" value="${stat.hospitalAntiAmount}"/></c:if></td>
                <td align="left">门诊：含急诊、儿科、草药</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">金额比例</td>
                <td><c:if test="stat.clinicAmount+stat.hospitalAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicAntiAmount+stat.hospitalAntiAmount) * 100.0 / (stat.clinicAmount+stat.hospitalAmount) }"/></c:if>%
                </td>
                <td><c:if test="stat.clinicAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiAmount * 100.0 / stat.clinicAmount}"/></c:if>%</td>
                <td><c:if test="stat.hospitalAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalAntiAmount * 100.0 / stat.hospitalAmount}"/></c:if>%</td>
                <td align="left">抗菌药金额／总药品金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">使用率</td>
                <td>-</td>
                <td><c:if test="stat.clinicPatient2>0"><fmt:formatNumber type="percent" maxFractionDigits="2" value="${stat.clinicAntiPatient2 * 1.0 / stat.clinicPatient2}"/></c:if></td>
                <td><c:if test="stat.outHospitalPatient>0"><fmt:formatNumber type="percent" maxFractionDigits="2" value="${stat.outAntiPatient * 1.0 / stat.outHospitalPatient}"/></c:if></td>
                <td align="left">门诊：抗菌药处方数／就诊人次(${stat.clinicPatient2})<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（急诊、儿科、草药除外）
                    <br/>住院：抗菌药用药人数／出院人数(${stat.outHospitalPatient}) <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（整个住院期间用过抗菌药的）
                </td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">平均费用</td>
                <td>-</td>
                <td>￥<c:if test="stat.clinicAntiPatient2>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiAmount2 / stat.clinicAntiPatient2}"/></c:if></td>
                <td>￥<c:if test="stat.outAntiPatient>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.outAntiAmount / stat.outAntiPatient}"/></c:if></td>
                <td align="left">抗菌药总金额／抗菌药用药人数<br/>(门诊：${stat.clinicAntiPatient2}，住院：${stat.outAntiPatient})</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">平均品种数</td>
                <td>-</td>
                <td><c:if test="stat.clinicAntiPatient2>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicAntiNum * 1.0 / stat.clinicAntiPatient2}"/></c:if></td>
                <td><c:if test="stat.outAntiPatient>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.outAntiNum * 1.0 / stat.outAntiPatient}"/></c:if></td>
                <td align="left">抗菌药品种数／抗菌药用药人数</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">注射金额比例</td>
                <td><c:if test="stat.clinicAmount+stat.hospitalAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicInjectAntiAmount+stat.hospitalInjectAntiAmount)*100.0/(stat.clinicAmount+stat.hospitalAmount)}"/></c:if>%
                </td>
                <td><c:if test="stat.clinicAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicInjectAntiAmount*100.0/stat.clinicAmount}"/></c:if>%</td>
                <td><c:if test="stat.hospitalAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalInjectAntiAmount*100.0/stat.hospitalAmount}"/></c:if>%</td>
                <td align="left">注射抗菌药药品金额／药品总金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">注射使用率</td>
                <td>-</td>
                <td><c:if test="stat.clinicPatient2>0">fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicInjectAntiPatient*1.0/stat.clinicPatient}"/></c:if></td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.outInjectAntiPatient*1.0/stat.outHospitalPatient}"/></td>
                <td align="left">门诊：注射抗菌药人数(${stat.clinicInjectAntiPatient})／门诊人数<br/>住院：注射抗菌药出院人数(${stat.outInjectAntiPatient})<br/>／出院人数
                </td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">抗菌药物<br/>使用强度</td>
                <td>-</td>
                <td>-</td>
                <td><c:if test="stat.hospitalDay>0"><fmt:formatNumber type="NUMBER" maxFractionDigits="2" value="${stat.DDDs*100.0/stat.hospitalDay}"/></c:if></td>
                <td align="left">抗菌药物消耗量（累计DDD数）*100 <br/>／同期收治患者住院天数(${stat.hospitalDay}) <br/>（去除出院带药，不含留观号）</td>
            </tr>
          <%--  <tr align="right">
                <td bgColor="#75c8cc" align="center">急诊抗菌<br/>药物处方比例</td>
                <td>-</td>
                <td><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.emergAntiPatient*1.0/stat.emergPatient}"/></td>
                <td>-</td>
                <td align="left">急诊抗菌药病人数／急诊用药病人数(${stat.emergPatient})</td>
            </tr>--%>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">特殊品种费用<br/>占抗菌药比例</td>
                <td><c:if test="stat.clinicAntiAmount+stat.hospitalAntiAmount>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2"
                                      value="${(stat.clinicSpecAntiAmount+stat.hospitalSpecAntiAmount)*1.0/(stat.clinicAntiAmount+stat.hospitalAntiAmount)}"/></c:if></td>
                <td><c:if test="stat.clinicAntiAmount>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.clinicSpecAntiAmount*1.0/stat.clinicAntiAmount}"/></c:if></td>
                <td><c:if test="stat.hospitalAntiAmount>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.hospitalSpecAntiAmount*1.0/stat.hospitalAntiAmount}"/></c:if></td>
                <td align="left">特殊抗菌药金额／抗菌药总金额</td>
            </tr>
            <tr align="right">
                <td bgColor="#75c8cc" align="center">口服抗菌药<br/>占抗菌药金额</td>
                <td><c:if test="stat.clinicAntiAmount+stat.hospitalAntiAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2"
                                      value="${(stat.clinicOrallyAntiAmount+stat.hospitalOrallyAntiAmount)*100.0/(stat.clinicAntiAmount+stat.hospitalAntiAmount)}"/></c:if>%
                </td>
                <td><c:if test="stat.clinicAntiAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.clinicOrallyAntiAmount*100.0/stat.clinicAntiAmount}"/></c:if>%</td>
                <td><c:if test="stat.hospitalAntiAmount>0"><fmt:formatNumber type="number" maxFractionDigits="2" value="${stat.hospitalOrallyAntiAmount*100.0/stat.hospitalAntiAmount}"/></c:if>%</td>
                <td align="left">口服抗菌药金额／抗菌药总金额</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center">门诊抗菌药<br/>静脉注射人次</td>
                <td align="right">-</td>
                <td align="right">${stat.clinicInjectAntiPatient}</td>
                <td align="right">-</td>
                <td align="left">含急诊</td>
            </tr>
            <tr>
                <td bgColor="#75c8cc" align="center" rowspan="5">急诊指标</td>
                <td align="center" colspan="3">急诊抗菌药物处方比例<%--<br>
                    <span style="font-size:70%">急诊抗菌药病人数／急诊用药病人数</span>--%></td>
                <td align="center"><c:if test="stat.emergPatient>0"><fmt:formatNumber type="PERCENT" maxFractionDigits="2" value="${stat.emergAntiPatient*1.0/stat.emergPatient}"/></c:if></td>
            </tr>
            <tr>
                <td align="center" colspan="3">急诊用抗菌药品种数</td>
                <td align="center">${stat.emergAntiInjectDrugNum}</td>
            </tr>
            <tr>
                <td colspan="3" align="center">急诊抗菌药静脉注射病人数</td>
                <td align="center">${stat.emergAntiInjectPatient}</td>
            </tr>
            <tr>
                <td colspan="3" align="center">急诊抗菌药物费用</td>
                <td align="center">￥<fmt:formatNumber type="NUMBER" maxFractionDigits="0" value="${stat.emergAntiDrugMoney}"/></td>
            </tr>
            <tr>
                <td colspan="3" align="center">急诊药物费用</td>
                <td align="center">￥<fmt:formatNumber type="NUMBER" maxFractionDigits="0" value="${stat.emergDrugMoney}"/></td>
            </tr>
        </table>
        <div class="row col-xs-12" style="height: 10px"></div>
        <table border="1" class="row col-xs-12" cellspacing="0" bordercolor="#336666" style="border-collapse:collapse">
            <tr>
                <td colspan="6" height="30" align="center"><span style="font-size: 16px;font-weight: bold;">基本药物</span></td>
            </tr>
            <tr>
                <td align="center" bgColor="#75c8cc"><strong>指标</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>品种数</strong></td>
                <td align="center" bgColor="#75c8cc"><strong>药品金额</strong></td>
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