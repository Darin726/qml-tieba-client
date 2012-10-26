#include "scribblearea.h"
#include <QPainter>

ScribbleArea::ScribbleArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    m_image = QImage(1, 1, QImage::Format_RGB32);
    m_penWidth = 5;
    m_modified = false;

    setFlag(QGraphicsItem::ItemHasNoContents, false);
    setAcceptedMouseButtons(Qt::LeftButton);
}

bool ScribbleArea::open(const QString &fileName)
{
    QImage loadedImage;
    if (!loadedImage.load(fileName))
        return false;

    if (loadedImage.height()>boundingRect().height() || loadedImage.width()>boundingRect().width())
        m_image = loadedImage.scaled(boundingRect().size().toSize(), Qt::KeepAspectRatio);
    else
        m_image = loadedImage;
    resizeImage(&m_image, boundingRect().size().toSize());
    setModified(false);
    return true;
}

bool ScribbleArea::save(const QString &fileName)
{
    QImage visibleImage = m_image;
    resizeImage(&visibleImage, boundingRect().size().toSize());
    if (visibleImage.save(fileName)){
        setModified(false);
        return true;
    } else {
        return false;
    }
}

void ScribbleArea::clear()
{
    m_image.fill(qRgb(255, 255, 255));
    update();
    setModified(true);
}

void ScribbleArea::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    painter->drawImage(boundingRect(), m_image, boundingRect());
}

void ScribbleArea::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    if (newGeometry.width() > m_image.width() || newGeometry.height() > m_image.height())
        resizeImage(&m_image, QSize(newGeometry.width(), newGeometry.height()));
}

void ScribbleArea::resizeImage(QImage *image, const QSize &newSize)
{
    if (image->size() == newSize)
        return;
    QImage newImage(newSize, QImage::Format_RGB32);
    newImage.fill(qRgb(255, 255, 255));
    QPainter p(&newImage);
    p.drawImage(QPoint(0,0), *image);
    *image = newImage;

    update();
    setModified(true);
}

void ScribbleArea::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    if (this->isEnabled()&&event->buttons()&&Qt::LeftButton)
    {
        lastPoint = event->pos();
        QPainter p(&m_image);
        p.setPen(QPen(QBrush(m_color),m_penWidth, Qt::SolidLine, Qt::RoundCap));
        p.drawPoint(lastPoint);
        update(lastPoint.x() - m_penWidth,
               lastPoint.y() - m_penWidth,
               m_penWidth * 2,
               m_penWidth * 2);
    }
}

void ScribbleArea::mouseMoveEvent(QGraphicsSceneMouseEvent *event)
{
    if (this->isEnabled()&&event->buttons()&&Qt::LeftButton)
    {
        endPoint = event->pos();
        drawLine();
    }
}
void ScribbleArea::mouseReleaseEvent(QGraphicsSceneMouseEvent *event)
{
    if (this->isEnabled() && event->button() == Qt::LeftButton)
    {
        endPoint = event->pos();
        drawLine();
    }
}

void ScribbleArea::drawLine()
{
    QPainter p(&m_image);
    p.setPen(QPen(QBrush(m_color),m_penWidth, Qt::SolidLine, Qt::RoundCap));
    p.drawLine(lastPoint, endPoint);
    update(qMin(lastPoint.x(), endPoint.x()) - m_penWidth,
           qMin(lastPoint.y(), endPoint.y()) - m_penWidth,
           qAbs(lastPoint.x() - endPoint.x()) + m_penWidth*2,
           qAbs(lastPoint.y() - endPoint.y()) + m_penWidth*2);
    lastPoint = endPoint;
}
